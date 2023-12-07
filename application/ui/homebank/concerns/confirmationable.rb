module Homebank
  module Concerns
    module Confirmationable

      def helb_dialog
        dialog = basic_dialog(title: 'Online documentation',
                              message: 'Do you want to read the online manual?',
                              second_message: "The Link will you redirect to the " \
                                "documentation website. The help pages are " \
                                "maintained and translated where.")

        link_button = Gtk::LinkButton.new('https://github.com/sabinahofmann/homebank-gtk-app', 'Read online')
        accept_button = dialog.child.last_child.get_child_at(0, 0)
        dialog.child.last_child.remove(accept_button)
        dialog.child.last_child.attach(link_button, 0, 0, 1, 1)

        cancel_button = dialog.child.last_child.get_child_at(1, 0)
        dialog.child.last_child.remove(cancel_button)

        dialog.show
      end

      def basic_dialog(**args)
        builder = Gtk::Builder.new(resource: '/de/hofmann/homebank-gtk/ui/dialog_window.ui')
        dialog = builder["window"]
        dialog.title = args[:title] || 'Confirmation'

        label = builder['message_label']
        label.label = args[:message]

        if args[:second_message]
          grid = builder['message_grid']
          second_label = Gtk::Label.new.set_markup(args[:second_message], use_underline: true)
          grid.attach(second_label, 0, 1, 1, 1)
        end

        button = builder["cancel"]
        button.signal_connect("clicked") { dialog.destroy }

        dialog
      end
    end
  end
end
