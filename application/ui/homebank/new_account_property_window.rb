module Homebank
  class NewAccountPropertyWindow < Gtk::Dialog
    # Register the class in the GLib world
    type_register

    class << self
      def init
        # Set the template from the resources binary
        set_template resource: '/de/hofmann/homebank-gtk/ui/new_account_property_window.ui'
      end
    end

    def initialize(application)
      super application: application
    end
  end
end
