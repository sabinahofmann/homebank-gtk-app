module Homebank
  class ApplicationWindow < Gtk::Window
    # Register the class in the GLib world
    type_register

    class << self
      def init
        # Set the template from the resources binary
        set_template resource: '/de/hofmann/homebank-gtk/ui/application_window.ui'

        bind_template_child 'add_new_account_button'
        bind_template_child 'account_list_box'
        bind_template_child 'status_bar'
        bind_template_child 'cancel'
        bind_template_child 'new_account'
      end
    end

    def initialize(application)
      super application: application

      set_title 'CSV Convertor'

      #status_bar
      context_id = status_bar.get_context_id("status")

      # menu bar
      cancel.signal_connect "activate" do
        close
      end

      new_account.signal_connect "activate" do
        add_account
      end

      # add new account
      add_new_account_button.signal_connect 'clicked' do |button|
        add_account
      end

      accounts = load_accounts

      # push statusbar
      on_push_status_bar(context_id, accounts.size)
    end

    def add_account
      new_account_window = Homebank::NewAccountWindow.new(application, Homebank::Account.new(user_data_path: application.user_data_path))
      new_account_window.present
    end

    def load_accounts
      account_list_box.children.each { |child| account_list_box.remove child }

      json_files = Dir[File.join(File.expand_path(application.user_data_path), '*.json')]
      items = json_files.map{ |filename| Homebank::Account.new(filename: filename) }

      items.each do |item|
        account_list_box.add Homebank::AccountListBoxRow.new(item)
      end
      items
    end

    def on_push_status_bar(context_id, counter)
      status_bar.push(context_id, "Accounts: #{counter}")
    end
  end
end

