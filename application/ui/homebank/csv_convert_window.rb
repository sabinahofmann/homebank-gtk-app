require 'csv'
require_relative 'concerns/confirmationable'

module Homebank
  class CsvConvertWindow < Gtk::Window
    include Concerns::Confirmationable

    attr_reader :csv_file_path

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
      filter.add_suffix('csv')


      file_chooser_button.signal_connect 'clicked' do
        fileDialog = Gtk::FileChooserDialog.new(:title => "Choose CSV File",
          :parent => self,
          :actions => :open,
          :buttons =>  [["_Cancel", :cancel], ["_Accept", :accept]])

        fileDialog.add_filter(filter)
        fileDialog.select_multiple = false

        fileDialog.signal_connect("response") do |_widget, response|
          if response == Gtk::ResponseType::ACCEPT
            #puts info.file.parse_name
            @csv_file_path = fileDialog.file.path
          end
            fileDialog.destroy
        end

        fileDialog.show
      end

      # convert cvs
      convert_button.signal_connect 'clicked' do
        result = Homebank::CsvConvertor.new( account: account, file: @csv_file_path ).generate
        result == true ? info_confirmation : error_confirmation
      end

      # cancel
      cancel_button.signal_connect 'clicked' do |button|
        close
      end
    end

    def info_confirmation
      dialog = confirmation_dialog(message: 'Converting completed', icon: Gtk::Stock::DIALOG_INFO,
                                    button_type_ok: true)
      dialog.signal_connect('response') do |widget, response|
        dialog.destroy && close if response == Gtk::ResponseType::OK
      end
    end

    def error_confirmation
      dialog = confirmation_dialog(message: 'Error converting file',
                                    icon: Gtk::Stock::DIALOG_ERROR, button_type_ok: true)
      dialog.signal_connect('response') do |widget, response|
        dialog.destroy if response == Gtk::ResponseType::OK
      end
    end
  end
end
