module Homebank
  class CvsConvertWindow < Gtk::Dialog
    type_register

    class << self
      def init
        set_template resource: '/de/hofmann/homebank-gtk/ui/cvs_convert_window.ui'

        bind_template_child 'convert_button'
        bind_template_child 'cancel_button'
      end
    end

    def initialize(application, item)
      super application: application

      # cancel
      cancel_button.signal_connect 'clicked' do |button|
        close
      end
    end

    def application
      parent = self.parent
      parent = parent.parent while !parent.is_a? Gtk::Dialog
      parent.application
    end
  end
end
