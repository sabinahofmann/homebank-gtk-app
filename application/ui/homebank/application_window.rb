require_relative 'concerns/confirmationable'

module Homebank
  class ApplicationWindow < Gtk::Window
    include Concerns::Confirmationable
    # Register the class in the GLib world
    type_register

    class << self
      def init
        # Set the template from the resources binary
        set_template resource: '/de/hofmann/homebank-gtk/ui/application_window.ui'

        bind_template_child 'new_account_button'
        bind_template_child 'account_list_box'
        bind_template_child 'main_box'
        bind_template_child 'stack'
        bind_template_child 'gears'
        bind_template_child 'file'
        bind_template_child 'status_label'
      end
    end

    def initialize(application)
      builder = Gtk::Builder.new(resource: '/de/hofmann/homebank-gtk/ui/menu.ui')

      super application: application

      file.menu_model = builder["file_menu"]
      gears.menu_model = builder["menu"]

      @account_counter = 0

      %w[help about quit new_account delete_all].each do |action_name|
        action = Gio::SimpleAction.new(action_name)
        action.signal_connect("activate") do |_action, _parameter|
          __send__("#{action_name}_activated")
        end
        application.add_action(action)
      end

      # add new account
      new_account_button.signal_connect 'clicked' do |button|
        add_account(application)
      end

      load_accounts
      show
    end

    def new_account_activated
      #add_account(self.super)
    end

    def about_activated
    end
    def help_activated
    end

    def quit_activated
      destroy
    end

    def add_account(application)
      AccountWindow.new(application, Account.new(user_data_path: application.user_data_path))
    end

    def load_accounts
      account_list_box.children.each { |child| account_list_box.remove child }

      json_files = Dir[File.join(File.expand_path(application.user_data_path), '*.json')]
      items = json_files.map{ |filename| Account.new(filename: filename) }

      items.each do |item|
        account_list_box.append AccountListBoxRow.new(item)
      end
      # push statusbar
      @account_counter = items.size
      update_status
    end

    def update_status
      status_label.text = "Accounts: #{@account_counter}"
    end

    # TODO delete + Dialog
    def delete_confirmation
      # GTK::Dialog
      dialog = confirmation_dialog(title: 'Delete confirmation',
                                   message: 'Do you really want to delete?',
                                   icon: Gtk::Stock::HELP,
                                   button_type_ok: true, button_type_cancel: true)

      dialog.signal_connect('response') do |response|
        FileUtils.rm_f Dir.glob("#{application.user_data_path}/*")
        json_files = Dir[File.join(File.expand_path(application.user_data_path), '*.json')]
        items = json_files.map{ |filename| Account.new(filename: filename) }
        items.each do |item|
          item.delete!
        end
        load_accounts
        dialog.close
      end
    end
  end
end

