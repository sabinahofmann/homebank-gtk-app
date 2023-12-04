module Homebank
  class AboutDialog

    def self.show(parent)
      dialog = Gtk::AboutDialog.show(parent,
              program_name: 'CSV convertor',
              version: '0.2',
              copyright: '(C) 2023 Sabina Hofmann',
              license: 'MIT',
              website_label: 'homebank-gtk-app',
              website: 'https://github.com/sabinahofmann/homebank-gtk-app',
              comments: 'Converts any exported account statements as a csv file into readable csv format to import them into the Homebank application.',
              authors: %w(Sabina Hofmann),
              logo: GdkPixbuf::Pixbuf.new(file: 'csv_convertor_image.png'),
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
