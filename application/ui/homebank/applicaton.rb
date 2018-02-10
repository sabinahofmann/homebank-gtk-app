module Homebank
  class Application < Gtk::Application
    def initialize
      super 'de.hofmann.gtk-todo', Gio::ApplicationFlags::FLAGS_NONE

      signal_connect :activate do |application|
        window = Gtk::ApplicationWindow.new(application)
        window.set_title 'CVS Convertor'
        window.present
      end
    end
  end
end
