# frozen_string_literal: true

require 'csv'

module Homebank
  # read the selected monthly statement csv file
  # convert it to a readable csv format for the homebank application
  class CsvConvertor
    attr_reader :converted_csv, :file, :account, :timestamp, :translated_data

    CSV_OPTIONS = { col_sep: ';', encoding: 'iso-8859-1:utf-8', force_quotes: false }.freeze
    def initialize(**options)
      @file = options[:file]
      @account = options[:account]
      @converted_csv = converted_csv_filename
      @timestamp = @converted_csv && File.exist?(@converted_csv) ? File.mtime(@converted_csv) : Time.now
      @translated_data = []
    end

    def generate
      return unless @converted_csv

      touch_csv
      File.mtime(@converted_csv) > @timestamp
    end

    private

    def touch_csv
      return unless translate_data.any?

      File.delete(@converted_csv) if File.exist?(@converted_csv)

      CSV.open(@converted_csv, 'wb', col_sep: ';') do |csv|
        @translated_data.each do |line|
          csv << line
        end
      rescue StandardError => e
        puts e.full_message
        next
      end
    end

    def translate_data
      return unless @file

      @translated_data = []
      CSV.foreach(@file, **CSV_OPTIONS).with_index do |row, i|
        if i >= @account.start_line_csv && row.any?
          @translated_data << [date(row), @account.payment, '', payee(row), memo(row), row[@account.amount_csv],
                               row[@account.category_csv], tag(row)]
        end
      end
      @translated_data
    end

    def memo(row)
      memo = row[@account.memo_csv] || ''
      memo.gsub('\'', '')
    end

    def tag(row)
      tag = row[@account.tag_csv] || ''
      tag.gsub('\'', '')
    end

    def payee(row)
      payee = row[@account.payee_csv] || ''
      payee.gsub('\'', '')
    end

    def date(row)
      date = row[@account.date_csv] || Time.now.strftime('%d-%m-%Y')
      date.gsub('.', '-')
    end

    def converted_csv_filename
      "#{File.dirname(@file)}/#{@account.bank_name}-homebank-import.csv" if @file && csv?
    end

    def csv?
      file_type = File.extname(@file).downcase
      file_type == '.csv'
    end
  end
end
