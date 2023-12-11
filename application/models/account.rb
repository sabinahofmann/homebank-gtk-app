# frozen_string_literal: true

require 'securerandom'
require 'json'

module Homebank
  # model class for setting individual bank configuration, which is using to convert a readable csv file
  class Account
    PROPERTIES = %i[id bank_name notes start_line filename creation_datetime date payment
                    tag payee memo amount category].freeze

    attr_accessor(*PROPERTIES)

    %w[date tag memo amount category payee start_line].each do |field|
      define_method("#{field}_csv") { send(field) - 1 }
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
        send "#{property}=", properties[property.to_s]
      end
    rescue ArgumentError => e
      raise "Failed to load existing item: #{e.message}"
    end

    # Saves an item to its `filename` location
    def save!
      File.write(@filename, to_json)
    end

    def new?
      !File.exist? @filename
    end

    # Deletes an item
    def delete!
      raise 'Item is not saved!' if new?

      File.delete(@filename)
    end

    # Produces a json string for the item
    def to_json(*_args)
      result = {}
      PROPERTIES.each do |prop|
        result[prop] = send prop
      end
      result.to_json
    end
  end
end
