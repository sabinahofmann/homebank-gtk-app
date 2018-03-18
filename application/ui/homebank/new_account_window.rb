module Homebank
  class NewAccountWindow < Gtk::Dialog
    # Register the class in the GLib world
    type_register

    class << self
      def init
        # Set the template from the resources binary
        set_template resource: '/de/hofmann/homebank-gtk/ui/new_account_window.ui'

        # Bind the window's widgets
        bind_template_child 'id_value_label'
        bind_template_child 'bank_name_entry'
        bind_template_child 'start_line_entry'
        bind_template_child 'date_entry'
        bind_template_child 'payment_entry'
        bind_template_child 'info_entry'
        bind_template_child 'payee_entry'
        bind_template_child 'memo_entry'
        bind_template_child 'amount_entry'
        bind_template_child 'category_entry'
        bind_template_child 'notes_text_view'
        bind_template_child 'cancel_button'
        bind_template_child 'save_button'
        bind_template_child 'delete_button'
      end
    end

    def initialize(application, item)
      super application: application

      set_title "Account #{item.is_new? ? 'Create' : 'Edit' } Mode"

      id_value_label.text = item.id
      bank_name_entry.text = item.bank_name if item.bank_name
      start_line_entry.value = item.start_line if item.start_line
      date_entry.value = item.date if item.date
      payment_entry.value = item.payment if item.payment
      info_entry.value = item.info if item.info
      payee_entry.value = item.payee if item.payee
      memo_entry.value = item.memo if item.memo
      amount_entry.value = item.amount if item.amount
      category_entry.value = item.category if item.category
      notes_text_view.buffer.text = item.notes if item.notes

      # cancel
      cancel_button.signal_connect 'clicked' do |button|
        close
      end

      # delete
      delete_button.signal_connect 'clicked' do
        item.delete!

        #Locate the application window
        application_window = application.windows.find { |w| w.is_a? Homebank::ApplicationWindow }
        application_window.load_account
      end

      # save
      save_button.signal_connect 'clicked' do |button|
        item.bank_name = bank_name_entry.text
        item.start_line = start_line_entry.value
        item.date = date_entry.value
        item.payment = payment_entry.value
        item.info = info_entry.value
        item.payee = payee_entry.value
        item.memo = memo_entry.value
        item.amount = amount_entry.value
        item.category = category_entry.value
        item.notes = notes_text_view.buffer.text
        item.save!
        close
        # Locate the application window
        application_window = application.windows.find { |w| w.is_a? Homebank::ApplicationWindow }
        application_window.load_account
      end
    end
  end
end
