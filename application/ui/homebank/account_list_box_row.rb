module Homebank
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

      account_title_label.text = account.bank_name || ""

      import_button.signal_connect 'clicked' do
        cvs_convert_window = Homebank::CsvConvertWindow.new(application, account)
        cvs_convert_window.present
      end

      edit_button.signal_connect 'clicked' do
        new_account_window = Homebank::NewAccountWindow.new(application, account)
        new_account_window.present
      end

      delete_button.signal_connect 'clicked' do
        account.delete!
      end
    end

    def application
      parent = self.parent
      parent = parent.parent while !parent.is_a? Gtk::Window
      parent.application
    end
  end
end
