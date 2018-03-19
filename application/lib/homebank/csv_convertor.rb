require 'csv'

module Homebank
  class CsvConvertor

    attr_reader :homebank_csv, :csv_file, :account, :timestamp

    def initialize(options={})
      @csv_file = options[:file].filename
      @account = options[:account]
      @homebank_csv = homebank_filename
      @timestamp = File.exists?(@homebank_csv) ? File.mtime(@homebank_csv) : Time.now
    end

    def generate
      touch_csv
      File.mtime(@homebank_csv) > @timestamp ? true : false
    end

    private
    def touch_csv
      csv_data = translate_data

      if csv_data.any?
        File.delete(@homebank_csv) if File.exists?(@homebank_csv)

        CSV.open(@homebank_csv, "wb", { col_sep: ";" }) do |csv|
          csv_data.each do |line|
            csv << line
          end
        rescue Exception => exception
          puts exception.full_message
          next
        end
      end
    end

    def translate_data
      data = []
      options = { col_sep: ';', encoding: 'iso-8859-1:utf-8', force_quotes: false }
      if @csv_file
        CSV.foreach(@csv_file, options).with_index do |row, i|
          if i >= @account.start_line && row.any?
            tag = row[@account.tag]
            payee = row[@account.payee] || ""
            memo = row[@account.memo] || ""
            amount = row[@account.amount]
            category = row[@account.category]

            data << [date(row), @account.payment, '', payee.gsub("\"", ""), memo.gsub("\"", ""), amount, category, tag.gsub("\"", "")]
          end
        end
      end
      data
    end

    def date(row)
      date = row[@account.date] || Time.now.strftime("%d-%m-%Y")
      date.gsub(".", "-")
    end

    def homebank_filename
      "#{File.dirname(@csv_file)}/#{@account.bank_name}-homebank-import.csv"
    end
  end
end
