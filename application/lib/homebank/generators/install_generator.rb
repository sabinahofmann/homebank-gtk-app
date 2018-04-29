module Homebank::Generators
  class InstallGenerator

    ACCOUNT_INGDIBA = {
        id: '1', bank_name: 'INGDiBa', notes: 'an example for INGDiBa', start_line: 14, date: 1,
        payment: 0, tag: 3,  payee: 3, memo: 4, amount: 8, category: 4, filename: ''
    }
    ACCOUNT_DKB = {
        id: '2', bank_name: 'DKB', notes: 'an example for DKB', start_line: 8, date: 1,
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
          File.open(account[:filename],"w"){ |f| f.write account.to_json }
        end
      end
    end
  end
end
