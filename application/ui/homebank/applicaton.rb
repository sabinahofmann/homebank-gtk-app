module Homebank
  class Application < Gtk::Application
    def initialize
      super 'de.hofmann.homebank-gtk', Gio::ApplicationFlags::FLAGS_NONE

      signal_connect :activate do |application|
        window = Homebank::ApplicationWindow.new(application)
        window.present
      end
    end
  end
end
