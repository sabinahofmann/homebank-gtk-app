# frozen_string_literal: true

module Homebank
  module Concerns
    # Create common customizeable dialogs with editable buttons cancel and accept
    module Confirmationable
      def helb_dialog
        dialog = basic_dialog(title: 'Online documentation',
                              message: 'Do you want to read the online manual?',
                              second_message: 'The Link will you redirect to the documentation website.' \
                                              'The help pages are maintained and translated where.')

        remove_buttons(dialog)
        add_link_button(dialog)
        dialog.show
      end

      def basic_dialog(**args)
        accept_button, cancel_button, dialog, grid = init_dialog(args)

        if args[:second_message]
          second_label = Gtk::Label.new.set_markup(args[:second_message], use_underline: true)
          grid.attach(second_label, 0, 1, 1, 1)
        end

        if args[:ok_button]
          dialog.child.last_child.remove(accept_button)
          cancel_button.label = 'Okay'
        end
        dialog
      end

      private

      def add_link_button(dialog)
        link_button = Gtk::LinkButton.new('https://github.com/sabinahofmann/homebank-gtk-app', 'Read online')
        dialog.child.last_child.attach(link_button, 0, 0, 1, 1)
      end

      def remove_buttons(dialog)
        grid_with_buttons = dialog.child.last_child
        cancel_button = grid_with_buttons.get_child_at(1, 0)
        accept_button = grid_with_buttons.get_child_at(0, 0)
        grid_with_buttons.remove(accept_button)
        grid_with_buttons.remove(cancel_button)
      end

      def init_dialog(args)
        builder = Gtk::Builder.new(resource: '/de/hofmann/homebank-gtk/ui/dialog_window.ui')
        dialog = builder['window']
        label = builder['message_label']
        grid = builder['message_grid']
        cancel_button = builder['cancel']
        accept_button = builder['accept']
        # set title and main message
        dialog.title = args[:title] || 'Confirmation'
        label.label = args[:message]
        # set default action on cancel button
        cancel_button.signal_connect('clicked') { dialog.destroy }

        [accept_button, cancel_button, dialog, grid]
      end
    end
  end
end
