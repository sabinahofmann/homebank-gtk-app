# frozen_string_literal: true

module Homebank
  module Generators
    # Generate default configuration file of two german checking accounts
    class InstallGenerator
      attr_reader :account_de_ing, :account_de_dkb

      def initialize(file_path)
        @file_path = file_path

        @account_de_ing = {
          id: '1', bank_name: 'ING', notes: 'An example for Germany bank ING checking bank csv account',
          start_line: 16, date: 1, payment: 0, tag: 3, payee: 3, memo: 5, amount: 8, category: 4, filename: ''
        }
        @account_de_dkb = {
          id: '2', bank_name: 'DKB', notes: 'An example for Germany bank DKB checking account csv export',
          start_line: 8, date: 1, payment: 0, tag: 4, payee: 4, memo: 5, amount: 8, category: 3, filename: ''
        }
      end

      def start_setup
        create_basic_files
      end

      private

      def create_basic_files
        [@account_de_dkb, @account_de_ing].each do |account|
          account[:filename] = "#{@file_path}/#{account[:bank_name]}_#{account[:id]}.json"
          File.write(account[:filename], account.to_json)
        end
      end
    end
  end
end
