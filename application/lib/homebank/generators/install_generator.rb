module Homebank
  module Generators
    class InstallGenerator

      ACCOUNT_DE_ING = {
          id: '1', bank_name: 'ING', notes: 'An example for Germany bank ING checking bank csv account', start_line: 16, date: 1,
          payment: 0, tag: 3,  payee: 3, memo: 5, amount: 8, category: 4, filename: ''
      }
      ACCOUNT_DE_DKB = {
          id: '2', bank_name: 'DKB', notes: 'An example for Germany bank DKB checking account csv export', start_line: 8, date: 1,
          payment: 0, tag: 4,  payee: 4, memo: 5, amount: 8, category: 3, filename: ''
        }

      def initialize(file_path)
        @file_path = file_path
      end

      def start_setup
        create_basic_files
      end

      private

      def create_basic_files
        [ACCOUNT_DE_DKB, ACCOUNT_DE_ING].each do |account|
          account[:filename] =  "#{@file_path}/#{account[:bank_name]}_#{account[:id]}.json"
          unless File.exist? account[:filename]
            File.open(account[:filename],"w"){ |f| f.write account.to_json }
          end
        end
      end
    end
  end
end
