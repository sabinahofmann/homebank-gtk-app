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
              comments: 'Converts exported account statements into readable csv format for homebank csv import',
              authors: %w(Sabina Hofmann),
              logo: GdkPixbuf::Pixbuf.new(file: 'csv_convertor_image.png'),
              title: 'About CSV Convertor for Homebank',
              icon_name: 'help-about')
    end
  end
end
