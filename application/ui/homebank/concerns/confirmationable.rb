module Homebank
  module Concerns
    module Confirmationable

      def confirmation_contents
        dialog = confirmation_dialog( title: 'Online documentation',
                                      message: 'Do you want to read the manual online?',
                                      second_message: "You will be redirected to the " \
                                        "documentation website\nwhere the help pages are " \
                                        "maintained and translated.", icon: 'help-browser' )

        link_button = Gtk::LinkButton.new('https://github.com/sabinahofmann/homebank-gtk-app', 'Read online')
        link_button.use_underline = true
        link_button.image = Gtk::Image.new(stock: Gtk::Stock::HELP, icon: Gtk::IconSize::DIALOG)
        link_button.set_relief(:normal)
        link_button.valign = :center

        dialog.action_area.add(link_button)
        dialog.action_area.halign = :center
        dialog.action_area.border_width = 10
        dialog.show_all
        dialog.run
        dialog.destroy
      end

      def confirmation_dialog(**args)
        # ':title => nil, :parent => nil, :flags => 0, :buttons => nil'
        dialog = Gtk::Dialgitog.new(title: args[:title] || 'Confirmation', parent: self, flags: :modal)
        dialog.set_default_size(200,100)
        dialog.icon_name = args[:icon]

        label = Gtk::Label.new.set_markup("<b>#{args[:message]}</b>", use_underline: true)
        label.set_padding(10, 10)
        label.valign = :center
        label.hexpand = :true

        vbox = Gtk::Box.new(:vertical, 0)
        dialog.child.add(vbox)

        hbox1 = Gtk::Box.new(:horizontal, 0)
        hbox1.border_width = 5
        hbox1.valign = :center
        vbox.add(hbox1)
        hbox1.add(label)

        if args[:second_message]
          hbox2 = Gtk::Box.new(:horizontal, 0)
          hbox2.set_border_width(5)
          vbox.add(hbox2)

          second_label = Gtk::Label.new.set_markup(args[:second_message], use_underline: true)
          label.set_padding(10, 10)
          hbox2.add(second_label)
        end

        if args[:button_type_ok]
          ok_button = Gtk::Button.new(label: 'OK')
          ok_button.image = Gtk::Image.new(stock: Gtk::Stock::OK, icon: Gtk::IconSize::DIALOG)
          dialog.add_action_widget(ok_button, Gtk::ResponseType::OK)
        end

        if args[:button_type_cancel]
          cancel_button = Gtk::Button.new(label: 'Cancel')
          cancel_button.image = Gtk::Image.new(stock: Gtk::Stock::CANCEL, icon: Gtk::IconSize::DIALOG)
          dialog.add_action_widget(cancel_button, Gtk::ResponseType::CANCEL)
        end

        if args[:button_type_close]
          close_button = Gtk::Button.new(label: 'Close')
          close_button.image = Gtk::Image.new(stock: Gtk::Stock::CLOSE, icon: Gtk::IconSize::DIALOG)
          dialog.add_action_widget(close_button, Gtk::ResponseType::CLOSE)
        end

        dialog.signal_connect('response') do |widget, response|
          case response
          when Gtk::ResponseType::CLOSE
            dialog.destroy
          when Gtk::ResponseType::CANCEL
            dialog.destroy
          end
        end
        dialog.show_all
        dialog
      end
    end
  end
end
