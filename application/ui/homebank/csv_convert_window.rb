require 'csv'

module Homebank
  class CsvConvertWindow < Gtk::Dialog
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

      file_chooser_button.current_folder = GLib.home_dir

      # select file
      file_chooser_button.signal_connect 'selection_changed'  do |w|
        puts "change file"
        file_changed(file_chooser_button)
      end

      # filter only cvs
      filter = Gtk::FileFilter.new
      filter.name = "CSV Files"
      filter.add_pattern('*.csv')
      file_chooser_button.add_filter(filter)

      # convert cvs
      convert_button.signal_connect 'clicked' do
        options = { account: account, file: file_chooser_button }
        result = Homebank::CsvConvertor.new(options).generate
        result == true ? on_info : on_erro
      end

      # cancel
      cancel_button.signal_connect 'clicked' do |button|
        close
      end
    end

    def application
      parent = self.parent
      parent = parent.parent while !parent.is_a? Gtk::Dialog
      parent.application
    end

    # file method
    def file_changed(choo_file)
      file = choo_file.filename
      file = "" if file == nil
    end

    def on_info
      md = Gtk::MessageDialog.new :parent => self, 
          :flags => :destroy_with_parent, :type => :info, 
          :buttons_type => :close, :message => "Converting completed"
      md.run
      md.destroy
    end

    def on_erro
      md = Gtk::MessageDialog.new :parent => self, 
          :flags => :modal, :type => :error, 
          :buttons_type => :close, :message => "Error converting file"
      md.run
      md.destroy
    end
  end
end
