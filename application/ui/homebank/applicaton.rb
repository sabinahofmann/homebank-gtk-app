# frozen_string_literal: true

module Homebank
  # Init Main Window and load all uis
  class Application < Gtk::Application
    attr_reader :user_data_path

    def initialize
      super('de.hofmann.homebank-gtk', :flags_none)

      @user_data_path = File.expand_path('~/.homebank-gtk')
      unless File.directory?(@user_data_path)
        FileUtils.mkdir_p(@user_data_path)
        Generators::InstallGenerator.new(@user_data_path).start_setup
      end

      signal_connect :activate do |application|
        ApplicationWindow.new(application)
      end
    end
  end
end
