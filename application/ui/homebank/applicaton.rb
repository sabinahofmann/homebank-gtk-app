module Homebank
  class Application < Gtk::Application

    attr_reader :user_data_path

    def initialize
      super 'de.hofmann.homebank-gtk', Gio::ApplicationFlags::FLAGS_NONE

      @user_data_path = File.expand_path('~/.homebank-gtk')
      unless File.directory?(@user_data_path)
        FileUtils.mkdir_p(@user_data_path)
        Homebank::Generators::InstallGenerator.new(@user_data_path).start_setup
      end

      signal_connect :activate do |application|
        Homebank::ApplicationWindow.new(application).present
      end
    end
  end
end
