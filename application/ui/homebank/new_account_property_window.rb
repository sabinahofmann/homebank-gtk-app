module Homebank
  class NewAccountPropertyWindow < Gtk::Dialog
    # Register the class in the GLib world
    type_register

    class << self
      def init
        # Set the template from the resources binary
        set_template resource: '/de/hofmann/homebank-gtk/ui/new_account_property_window.ui'

        # Bind the window's widgets
        bind_template_child 'id_value_label'
        bind_template_child 'bank_name_entry'
        bind_template_child 'start_line_entry'
        bind_template_child 'date_position_label'
        bind_template_child 'info_position_label'
        bind_template_child 'payee_position_label'
        bind_template_child 'memo_position_label'
        bind_template_child 'amount_position_label'
        bind_template_child 'category_position_label'
        bind_template_child 'tags_position_label'
        bind_template_child 'notes_text_view'
        bind_template_child 'cancel_button'
        bind_template_child 'save_button'
      end
    end

    def initialize(application, item)
      super application: application
      set_title "Account #{item.is_new? ? 'Create' : 'Edit' } Mode"

      id_value_label.text = item.id
      bank_name_entry.text = item.bank_name if item.bank_name
      start_line_entry.text = item.start_line if item.start_line
      date_position_label.text = item.date if item.date
      info_position_label.text = item.info if item.info
      payee_position_label.text = item.payee if item.payee
      memo_position_label.text = item.memo if item.memo
      amount_position_label.text = item.amount if item.amount
      category_position_label.text = item.category if item.category
      tags_position_label.text = item.tags if item.tags
      notes_text_view.buffer.text = item.notes if item.notes

      # cancel
      cancel_button.signal_connect 'clicked' do |button|
        close
      end

      # save
      save_button.signal_connect 'clicked' do |button|
        item.bank_name = bank_name_entry.text
        item.start_line = start_line_entry.text
        item.date = date_position_label.text
        item.info = info_position_label.text
        item.payee = payee_position_label.text
        item.memo = memo_position_label.text
        item.amount = amount_position_label.text
        item.category = category_position_label.text
        item.tags = tags_position_label.text
        item.notes = notes_text_view.buffer.text
        item.save!
        close
      end
    end
  end
end
