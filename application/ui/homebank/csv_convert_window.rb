require 'csv'
require_relative 'concerns/confirmationable'

module Homebank
  class CsvConvertWindow < Gtk::Window
    include Concerns::Confirmationable

    attr_reader :file_path

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

      file_chooser_button.signal_connect 'clicked' do
        file_dialog = Gtk::FileDialog.new
        file_dialog.title = 'Choose CSV file'
        file_dialog.accept_label = 'Select'
        file_dialog.modal = true
        filters = Gtk::FilterListModel.new
        filters.filter = file_filter
        file_dialog.default_filter = file_filter
        file_dialog.filters = filters

        file_dialog.open do |dialog, gioTask|
          # return Gio::File
          selected_file = dialog.open_finish(gioTask)
          @file_path = selected_file.path
          file_chooser_button.label = File.basename(@file_path)
        end

      end

      # convert cvs
      convert_button.signal_connect 'clicked' do
        if @file_path
          result = Homebank::CsvConvertor.new( account: account, file: @file_path ).generate
          result ? info_confirmation : error_confirmation
        end
      end

      # cancel
      cancel_button.signal_connect 'clicked' do |button|
        close
      end
    end

    def info_confirmation
      dialog = basic_dialog(title: 'Success', message: 'Converting completed', ok_button: true)
      dialog.show
      close
    end

    def error_confirmation
      dialog = basic_dialog(title: 'Error', message: 'Error converting file', ok_button: true)
      dialog.show
      close
    end

    private

    def file_filter
      filter = Gtk::FileFilter.new
      filter.name = 'CSV Files'
      filter.add_pattern('*.csv')
      filter.add_suffix('csv')
      filter
    end
  end
end
