module Homebank
  class AboutDialog < Gtk::AboutDialog
    type_register

    class << self
      def init
        set_template resource: '/de/hofmann/homebank-gtk/ui/about_dialog.ui'
      end
    end

    def initialize(account)
      super()
    end
  end
end
