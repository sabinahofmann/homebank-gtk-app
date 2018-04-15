require 'csv'
require_relative 'concerns/confirmationable'

module Homebank
  class CsvConvertWindow < Gtk::Window
    include Concerns::Confirmationable
    type_register

    class << self
      def init
        set_template resource: '/de/hofmann/homebank-gtk/ui/csv_convert_window.ui'

        bind_template_child 'file_chooser_button'
        bind_template_child 'convert_button'
        bind_template_child 'cancel_button'
      end
    end

    def initialize(application, account)
      super application: application

      filter = Gtk::FileFilter.new
      filter.name = 'CSV Files'
      filter.add_pattern('*.csv')
      file_chooser_button.add_filter(filter)

      # select file
      file_chooser_button.current_folder = GLib.home_dir
      file_chooser_button.signal_connect 'selection_changed'  do |w|
        file_changed(file_chooser_button)
      end

      # convert cvs
      convert_button.signal_connect 'clicked' do
        result = Homebank::CsvConvertor.new({account: account, file: file_chooser_button}).generate
        result == true ? info_confirmation : error_confirmation
      end

      # cancel
      cancel_button.signal_connect 'clicked' do |button|
        close
      end
    end

    # file method
    def file_changed(choo_file)
      file = choo_file.filename
      file = "" if file == nil
    end

    def info_confirmation
      dialog = confirmation_dialog({message: 'Converting completed', icon: Gtk::Stock::DIALOG_INFO,
                                    button_type_ok: true})
      dialog.signal_connect('response') do |widget, response|
        dialog.destroy && close if response == Gtk::ResponseType::OK
      end
    end

    def error_confirmation
      dialog = confirmation_dialog({message: 'Error converting file',
                                    icon: Gtk::Stock::DIALOG_ERROR, button_type_ok: true})
      dialog.signal_connect('response') do |widget, response|
        dialog.destroy if response == Gtk::ResponseType::OK
      end
    end
  end
end
