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
        bind_template_child 'contents'
        bind_template_child 'delete_all' #TODO
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

      # delete
      delete_all.signal_connect 'activate' do
        if delete_confirmation == Gtk::ResponseType::OK
          FileUtils.rm_f Dir.glob("#{application.user_data_path}/*")
          load_accounts && push_status_bar
        end
      end

      # menu bar
      cancel.signal_connect 'activate' do
        close
      end

      contents.signal_connect 'activate' do
        on_contents
      end

      about.signal_connect 'activate' do
        Homebank::AboutDialog.new(application).present
      end

      # add new account
      new_account.signal_connect 'activate' do
        add_account
      end

      add_new_account_button.signal_connect 'clicked' do |button|
        add_account
      end
      # loads exists accounts
      load_accounts
      # push statusbar
      push_status_bar
      # show all widgets
      show_all
    end

    def add_account
      account_window = Homebank::NewAccountWindow.new(application, Homebank::Account.new(user_data_path: application.user_data_path))
      account_window.present
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

    def push_status_bar
      status_bar.push(@context_id, "Accounts: #{@account_counter}")
    end

    def on_contents
      m_dialog = Gtk::MessageDialog.new(parent: self, flags: :modal, type: :info, buttons_type: :none,
                                      message: 'Do you want to read the manual online?')
      m_dialog.title = 'Online documentation'
      m_dialog.secondary_text = 'You will be redirected to the documentation website where the help ' \
          'pages are maintained and translated.'
      m_dialog.image = Gtk::Image.new(stock: Gtk::Stock::INFO, icon: Gtk::IconSize::DIALOG)

      lbutton = Gtk::LinkButton.new('https://github.com/sabinahofmann/homebank-gtk-app', 'Read online')
      lbutton.use_underline = true
      lbutton.image = Gtk::Image.new(stock: Gtk::Stock::HELP, icon: Gtk::IconSize::DIALOG)
      lbutton.set_relief(:normal)

      m_dialog.action_area.add(lbutton)
      m_dialog.show_all
      m_dialog.run
      m_dialog.destroy
    end

    def delete_confirmation
      m_dialog = Gtk::MessageDialog.new(parent: self, flags: :modal, type: :question, 
          buttons_type: :ok_cancel, message: 'Do you really want to delete?')
      m_dialog.title = 'Delete confirmation'
      response = m_dialog.run
      m_dialog.destroy
      response
    end
  end
end

