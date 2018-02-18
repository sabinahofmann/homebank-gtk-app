module Homebank
  class ApplicationWindow < Gtk::ApplicationWindow
    # Register the class in the GLib world
    type_register

    class << self
      def init
        # Set the template from the resources binary
        set_template resource: '/de/hofmann/homebank-gtk/ui/application_window.ui'

        bind_template_child 'add_new_account_button'
      end
    end

    def initialize(application)
      super application: application

      set_title 'CVS Creator Simple'

      add_new_account_button.signal_connect 'clicked' do |button|
        new_account_property_window = Homebank::NewAccountPropertyWindow.new(application, Homebank::Account.new(user_data_path: application.user_data_path))
        new_account_property_window.present
      end
    end
  end
end

