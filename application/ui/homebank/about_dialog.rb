module Homebank
  class AboutDialog < Gtk::AboutDialog
    type_register

    class << self
      def init
        set_template resource: '/de/hofmann/homebank-gtk/ui/about_dialog.ui'
        bind_template_child 'button_box'
      end
    end

    def initialize(application)
      super application: application

      button_box.each_with_index do |but, i|
        case i
        when 0 then but.label = 'Credits'
        when 1 then but.label = 'License'
        when 2 then but.label = 'Close'
        end
      end

      if run == Gtk::ResponseType::DELETE_EVENT
       close
      end
    end
  end
end
