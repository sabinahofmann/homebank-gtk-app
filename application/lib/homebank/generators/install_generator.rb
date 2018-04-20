module Homebank::Generators
  class InstallGenerator

    ACCOUNT_INGDIBA = {
        id: '0', bank_name: 'IngDiba', notes: 'generatet example for DKB', start_line: 8, date: 1,
        payment: 0, tag: 4,  payee: 4, memo: 5, amount: 8, category: 3, filename: ''
    }
    ACCOUNT_DKB = {
        id: '0', bank_name: 'IngDiba', notes: 'generatet example for DKB', start_line: 8, date: 1,
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
      [ACCOUNT_DKB, ACCOUNT_INGDIBA].each do |account|
        account[:filename] =  "#{@file_path}/#{account[:id]}.json"
        unless File.exists? account[:filename]
          File.open(filename,"w"){ |f| f.write account.to_json }
        end
      end
    end
  end
end
