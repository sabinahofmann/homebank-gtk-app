module Homebank
  class Application < Gtk::Application

    attr_reader :user_data_path

    def initialize
      super 'de.hofmann.homebank-gtk', Gio::ApplicationFlags::FLAGS_NONE

      @user_data_path = File.expand_path('~/.homebank-gtk')
      unless File.directory?(@user_data_path)
        puts "First run. Creating user's application path: #{@user_data_path}"
        FileUtils.mkdir_p(@user_data_path)
      end

      signal_connect :activate do |application|
        window = Homebank::ApplicationWindow.new(application)
        window.present
      end
    end
  end
end
