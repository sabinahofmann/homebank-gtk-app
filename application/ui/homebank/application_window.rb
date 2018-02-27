module Homebank
  class ApplicationWindow < Gtk::Dialog
    # Register the class in the GLib world
    type_register

    class << self
      def init
        # Set the template from the resources binary
        set_template resource: '/de/hofmann/homebank-gtk/ui/application_window.ui'

        bind_template_child 'cancel_button'
        bind_template_child 'add_new_account_button'
        bind_template_child 'account_list_box'
      end
    end

    def initialize(application)
      super application: application

      set_title 'CVS Convertor'

      # cancel
      cancel_button.signal_connect 'clicked' do |button|
        close
      end

      # add new account
      add_new_account_button.signal_connect 'clicked' do |button|
        new_account_window = Homebank::NewAccountWindow.new(application, Homebank::Account.new(user_data_path: application.user_data_path))
        new_account_window.present
      end

      load_account
    end

    def load_account
      account_list_box.children.each { |child| account_list_box.remove child }

      json_files = Dir[File.join(File.expand_path(application.user_data_path), '*.json')]
      items = json_files.map{ |filename| Homebank::Account.new(filename: filename) }

      items.each do |item|
        account_list_box.add Homebank::AccountListBoxRow.new(item)
      end
    end
  end
end

