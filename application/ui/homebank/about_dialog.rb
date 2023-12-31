# frozen_string_literal: true

module Homebank
  # About Dialig with content
  class AboutDialog
    def self.show(parent)
      Gtk::AboutDialog.show(parent,
                            program_name: 'CSV convertor', version: '1.0.1',
                            copyright: '(C) 2023 Sabina Hofmann', license: 'MIT',
                            website_label: 'homebank-gtk-app',
                            website: 'https://github.com/sabinahofmann/homebank-gtk-app',
                            comments: 'Convert monthly statement into readable format for homebank csv import',
                            authors: %w[Sabina Hofmann],
                            logo: GdkPixbuf::Pixbuf.new(file: 'csv_convertor_image.png'),
                            title: 'About CSV Convertor for Homebank',
                            icon_name: 'help-about')
    end
  end
end
