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
        bind_template_child 'main_box'
        bind_template_child 'about'
      end
    end

    def initialize(application)
      super application: application

      set_title 'CSV Convertor'

      #status_bar
      @account_counter = 0
      @context_id = status_bar.get_context_id("status")

      #scrolled window
      main_box.remove(account_list_box)
      scrolled = Gtk::ScrolledWindow.new
      scrolled.set_policy(:never, :automatic)
      viewport  = Gtk::Viewport.new(scrolled.hadjustment, scrolled.vadjustment)
      account_list_box.expand = true
      viewport.add(account_list_box)
      scrolled.add(viewport)
      main_box.add(scrolled)

      # menu bar
      cancel.signal_connect "activate" do
        close
      end

      new_account.signal_connect "activate" do
        add_account
      end

      about.signal_connect 'activate' do
        Homebank::AboutDialog.new(application).present
      end

      # add new account
      add_new_account_button.signal_connect 'clicked' do |button|
        add_account
      end
      # loads exists accounts
      load_accounts
      # push statusbar
      on_push_status_bar
      # show all widgets
      show_all
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
      @account_counter = items.size
    end

    def on_push_status_bar
      status_bar.push(@context_id, "Accounts: #{@account_counter}")
    end
  end
end

