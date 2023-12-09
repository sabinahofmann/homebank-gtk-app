# frozen_string_literal: true

require 'csv'

module Homebank
  # read the selected monthly statement csv file
  # convert it to a readable csv format for the homebank application
  class CsvConvertor
    attr_reader :homebank_csv, :file, :account, :timestamp

    def initialize(**options)
      @file = options[:file]
      @account = options[:account]
      @homebank_csv = homebank_filename
      @timestamp = @homebank_csv && File.exist?(@homebank_csv) ? File.mtime(@homebank_csv) : Time.now
    end

    def generate
      return unless @homebank_csv

      touch_csv
      File.mtime(@homebank_csv) > @timestamp
    end

    private

    def csv?
      file_type = File.extname(@file).downcase
      file_type == '.csv'
    end

    def touch_csv
      csv_data = translate_data
      return unless csv_data.any?

      File.delete(@homebank_csv) if File.exist?(@homebank_csv)

      CSV.open(@homebank_csv, 'wb', col_sep: ';') do |csv|
        csv_data.each do |line|
          csv << line
        end
      rescue => e
        puts e.full_message
        next
      end
    end

    def translate_data
      return unless @file

      data = []
      options = { col_sep: ';', encoding: 'iso-8859-1:utf-8', force_quotes: false }
      CSV.foreach(@file, **options).with_index do |row, i|
        if i >= @account.start_line_csv && row.any?
          tag = row[@account.tag_csv] || ''
          payee = row[@account.payee_csv] || ''
          memo = row[@account.memo_csv] || ''
          amount = row[@account.amount_csv]
          category = row[@account.category_csv]
          payment = @account.payment

          data << [date(row), payment, '', payee.gsub('\'', ''), memo.gsub('\'', ''), amount, category,
                   tag.gsub('\'', '')]
        end
      end
      data
    end

    def date(row)
      date = row[@account.date_csv] || Time.now.strftime('%d-%m-%Y')
      date.gsub('.', '-')
    end

    def homebank_filename
      "#{File.dirname(@file)}/#{@account.bank_name}-homebank-import.csv" if @file && csv?
    end
  end
end
