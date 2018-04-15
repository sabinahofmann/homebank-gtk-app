module Homebank
  class AboutDialog

    def self.show(parent)
      dialog = Gtk::AboutDialog.show(parent,
              program_name: 'CSV convertor',
              version: '0.1',
              copyright: '(C) 2018 Sabina Hofmann',
              license: 'MIT',
              website_label: 'homebank-gtk-app',
              website: 'https://github.com/sabinahofmann/homebank-gtk-app',
              comments: 'Converts any csv in readable format for importing into the homebank application',
              authors: %w(Sabina Hofmann),
              logo_icon_name: 'gtk3-demo',
              title: 'About CSV Convertor for Homebank',
              icon_name: 'help-about')

      # modifiy button_box
      boxs = []
      dialog.child.each{ |c| c.each { |b| boxs << b } }
      boxs.last.each_with_index do |but, i|
        case i
        when 0 then but.label = 'Credits'
        when 1 then but.label = 'License'
        when 2 then but.label = 'Close'
        end
      end

      if dialog.run == Gtk::ResponseType::DELETE_EVENT
        dialog.close
      end
    end
  end
end
