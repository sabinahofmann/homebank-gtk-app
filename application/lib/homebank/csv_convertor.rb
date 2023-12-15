# frozen_string_literal: true

require 'csv'
require 'fileutils'

module Homebank
  # read the selected monthly statement csv file
  # convert it to a readable csv format for the homebank application
  class CsvConvertor
    attr_accessor :csv_filename, :file, :account, :translated_data

    CSV_OPTIONS = { col_sep: ';', encoding: 'iso-8859-1:utf-8', force_quotes: false }.freeze
    def initialize(**options)
      @file = options[:file]
      @account = options[:account]
      @csv_filename = new_csv_filename
      translate_data
    end

    def generate
      return unless @csv_filename

      touch_csv
      File.mtime(@csv_filename) > timestamp
    end

    private

    def timestamp
      @csv_filename && File.exist?(@csv_filename) ? File.mtime(@csv_filename) : Time.now
    end

    def translate_data
      @translated_data = []
      return unless @file

      CSV.foreach(@file, **CSV_OPTIONS).with_index do |row, i|
        if i >= @account.start_line_csv && row.any?
          @translated_data << [date(row), @account.payment, '', payee(row), memo(row), row[@account.amount_csv],
                               row[@account.category_csv], tag(row)]
        end
      end
    end

    def new_csv_filename
      "#{File.dirname(@file)}/#{@account.bank_name}-homebank-import.csv" if @file && csv?
    end

    def touch_csv
      return unless @translated_data.any?

      FileUtils.rm_f(@csv_filename)

      CSV.open(@csv_filename, 'wb', col_sep: ';') do |csv|
        @translated_data.each do |line|
          csv << line
        end
      rescue StandardError => e
        puts e.full_message
        next
      end
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

    def csv?
      file_type = File.extname(@file).downcase
      file_type == '.csv'
    end
  end
end
