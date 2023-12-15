# frozen_string_literal: true

module Homebank
  # Component list all account in main window
  class AccountListBoxRow < Gtk::ListBoxRow
    type_register

    class << self
      def init
        set_template resource: '/de/hofmann/homebank-gtk/ui/account_list_box_row.ui'

        bind_template_child 'account_title_label'
        bind_template_child 'import_button'
        bind_template_child 'edit_button'
        bind_template_child 'delete_button'
      end
    end

    def initialize(account)
      super()

      account_title_label.text = account.bank_name || ''
      # button events
      import_button.signal_connect('clicked') { CsvConvertWindow.new(application, account).present }

      edit_button.signal_connect('clicked') { AccountWindow.new(application, account).present }

      delete_button.signal_connect 'clicked' do
        delete_button_event(account)
      end
    end

    private

    def delete_button_event(account)
      account.delete!
      application_window.load_accounts
    end

    def application
      parent = self.parent
      parent = parent.parent until parent.is_a? Gtk::Window
      parent.application
    end

    def application_window
      application.windows.find { |w| w.is_a? Homebank::ApplicationWindow }
    end
  end
end
