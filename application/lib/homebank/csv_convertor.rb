require 'csv'

module Homebank
  class CsvConvertor

    attr_reader :bank_csv, :homebank_csv, :options, :csv_file, :account

    def initialize(account, csv_file)
      @account = account
      @bank_csv = []
      @homebank_csv = "homebank-import-#{account.bank_name}.csv"
      @options = { col_sep: ';', encoding: 'iso-8859-1:utf-8', force_quotes: false}
      @csv_file = csv_file.filename
    end

    def generate
      transform && save_file
    end

    private
    def transform
        CSV.foreach(@csv_file, @options).with_index do |row, i|

          line_start = @account.start_line.to_i >= 0 ? 7 : @account.start_line.to_i
          if i >= line_start && row.any?

            date = row[@account.date.to_i].gsub(".", "-")
            payment = row[@account.payment.to_i] || 0
            info = row[@account.info.to_i] || ''
            payee = row[@account.payee.to_i].gsub("\"", "")
            memo = row[@account.memo.to_i].gsub("\"", "")
            amount = row[@account.amount.to_i]
            category = row[@account.category.to_i]

            line =  [date,  payment, info, payee, memo, amount, category]
            @bank_csv << line
          end
        end
    end

    def save_file
      File.delete(@homebank_csv) if File.exists?(@homebank_csv)

      CSV.open(@homebank_csv, "wb", { :col_sep => ";" }) do |csv|
        @bank_csv.each do |line|
          csv << line
        end
      end
    end
  end
end
