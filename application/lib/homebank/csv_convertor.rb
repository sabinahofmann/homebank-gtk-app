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
      if File.mtime(@homebank_csv) > @timestamp
        true
      else
        false
      end
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

          line_start = @account.start_line.to_i >= 0 ? 7 : @account.start_line.to_i
          if i >= line_start && row.any?

            date = row[@account.date.to_i].gsub(".", "-")
            payment = row[@account.payment.to_i] || 0
            info = row[@account.info.to_i] || ''
            payee = row[@account.payee.to_i].gsub("\"", "")
            memo = row[@account.memo.to_i].gsub("\"", "")
            amount = row[@account.amount.to_i]
            category = row[@account.category.to_i]

            data << [date,  payment, info, payee, memo, amount, category]
          end
        end
      end
      return data
    end
  end
end
