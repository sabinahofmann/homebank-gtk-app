require 'csv'

module Homebank
  class CsvConvertor

    attr_reader :homebank_csv, :csv_file, :account

    def initialize(options={})
      @account = options[:account]
      @homebank_csv = "#{options[:user_data_path]}/homebank-import-#{@account.bank_name}.csv"
      @csv_file = options[:file].filename
    end

    def generate
      data = read_file
      write_file(data) if data.any?
    end

    private
    def read_file
      data = []
      options = { col_sep: ';', encoding: 'iso-8859-1:utf-8', force_quotes: false }
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
      data
    end

    def write_file(data)
      File.delete(@homebank_csv) if File.exists?(@homebank_csv)

      CSV.open(@homebank_csv, "wb", { :col_sep => ";" }) do |csv|
        data.each do |line|
          csv << line
        end
      end
    end
  end
end
