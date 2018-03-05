module Homebank
  class CvsConvertWindow < Gtk::Dialog
    type_register

    class << self
      def init
        set_template resource: '/de/hofmann/homebank-gtk/ui/cvs_convert_window.ui'

        bind_template_child 'file_chooser_button'
        bind_template_child 'convert_button'
        bind_template_child 'cancel_button'
      end
    end

    def initialize(application, item)
      super application: application

      file_chooser_button = Gtk::FileChooserButton.new(
        "Select a file", Gtk::FileChooserAction::SELECT_FOLDER)
      file_chooser_button.current_folder = GLib.home_dir

      # filter only cvs
      filter = Gtk::FileFilter.new
      filter.name = "CVS Files"
      filter.add_pattern('*.cvs')
      file_chooser_button.add_filter(filter)

      # select file
      file_chooser_button.signal_connect 'selection_changed'  do |w|
        file_changed(choo_file_btt, label)
      end

      # convert cvs
      convert_button.signal_connect 'clicked' do
        puts "convert button #1 clicked"
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
    def file_changed(choo_file, label)
      file = choo_file.filename
      file = "" if file == nil
      label.text = file
    end
  end
end
