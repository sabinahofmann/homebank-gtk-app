module Homebank
  class AccountListBoxRow < Gtk::ListBoxRow
    type_register

    class << self
      def init
        set_template resource: '/de/hofmann/homebank-gtk/ui/account_list_box_row.ui'

        bind_template_child 'account_details_button'
        bind_template_child 'account_title_label'
        bind_template_child 'account_details_revealer'
        bind_template_child 'account_notes_text_view'
        bind_template_child 'select_button'
        bind_template_child 'edit_button'
      end
    end

    def initialize(item)
      super()

      account_title_label.text = item.bank_name || ""
      account_notes_text_view.buffer.text = item.notes

      account_details_button.signal_connect 'clicked' do
        account_details_revealer.set_reveal_child !account_details_revealer.reveal_child?
      end

      select_button.signal_connect 'clicked' do
        cvs_convert_window = Homebank::CsvConvertWindow.new(application, item)
        cvs_convert_window.present
      end

      edit_button.signal_connect 'clicked' do
        new_account_window = Homebank::NewAccountWindow.new(application, item)
        new_account_window.present
      end
    end

    def application
      parent = self.parent
      parent = parent.parent while !parent.is_a? Gtk::Dialog
      parent.application
    end
  end
end
