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
      new_account_button.signal_connect('clicked') { add_account }

      load_accounts
      show
    end

    def new_account_activated
      add_account
    end

    def about_activated
      AboutDialog.show(self)
    end
    def help_activated
      helb_dialog
    end

    def quit_activated
      destroy
    end

    def add_account
      AccountWindow.new(self.application, Account.new(user_data_path: application.user_data_path))
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

    def delete_all_activated
      dialog = basic_dialog(title: 'Delete confirmation',
                                   message: 'Do you really want to delete?')

      accept_button = dialog.child.last_child.get_child_at(0, 0)
      accept_button.label = 'Yes'
      accept_button.signal_connect 'clicked' do
        delete_accounts && load_accounts
        dialog.destroy
      end
      dialog.show
    end

    private

    def delete_accounts
      FileUtils.rm_f Dir.glob("#{application.user_data_path}/*")
      json_files = Dir[File.join(File.expand_path(application.user_data_path), '*.json')]
      items = json_files.map { |filename| Account.new(filename: filename) }
      items.each do |item|
        item.delete!
      end
    end
  end
end

