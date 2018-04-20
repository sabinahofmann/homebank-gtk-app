require 'securerandom'
require 'json'

module Homebank
  class Account

    PROPERTIES = %i(id bank_name notes start_line filename creation_datetime date payment
     tag payee memo amount category).freeze

    attr_accessor *PROPERTIES

    %w(date tag memo amount category payee start_line).each do |field|
      define_method("#{field}_csv") { self.send(field)-1 }
    end

    def initialize(**options)
      if options[:user_data_path]
        # New item. When saved, it will be placed under the :user_data_path value
        @id = SecureRandom.uuid
        @creation_datetime = Time.now
        @filename = "#{options[:user_data_path]}/#{id}.json"
      elsif options[:filename]
        load_from_file options[:filename] # Load an existing item
      else
        raise ArgumentError, 'Please specify the :user_data_path for new item or the :filename to load existing'
      end
    end

    # Loads an item from a file
    def load_from_file(filename)
      properties = JSON.parse(File.read(filename))
      # Assign the properties
      PROPERTIES.each do |property|
        self.send "#{property}=", properties[property.to_s]
      end
    rescue => e
      raise ArgumentError, "Failed to load existing item: #{e.message}"
    end

    # Saves an item to its `filename` location
    def save!
      File.open(@filename, 'w') do |file|
        file.write self.to_json
      end
    end

    def is_new?
      !File.exists? @filename
    end

    # Deletes an item
    def delete!
      raise 'Item is not saved!' if is_new?

      File.delete(@filename)
    end

    # Produces a json string for the item
    def to_json
      result = {}
      PROPERTIES.each do |prop|
        result[prop] = self.send prop
      end
      result.to_json
    end
  end
end
