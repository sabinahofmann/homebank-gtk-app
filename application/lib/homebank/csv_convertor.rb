require 'csv'

module Homebank
  class CsvConvertor

    attr_reader :homebank_csv, :csv_file, :account, :timestamp

    def initialize(options={})
      @account = options[:account]
      @homebank_csv = "#{options[:user_data_path]}/homebank-import-#{@account.bank_name}.csv"
      @timestamp = File.exists?(@homebank_csv) ? File.mtime(@homebank_csv) : Time.now
      @csv_file = options[:file].filename
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

        CSV.open(@homebank_csv, "wb", { :col_sep => ";" }) do |csv|
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
            payment = row[@account.payment]
            info = row[@account.info]
            payee = row[@account.payee] || ""
            memo = row[@account.memo] || ""
            amount = row[@account.amount]
            category = row[@account.category]

            data << [date(row),  payment, info, payee.gsub("\"", ""), memo.gsub("\"", ""), amount, category]
          end
        end
      end
      return data
    end

    def date(row)
      date = row[@account.date] || Time.now.strftime("%d-%m-%Y")
      date.gsub(".", "-")
    end
  end
end
