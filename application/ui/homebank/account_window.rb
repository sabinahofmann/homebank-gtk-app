# frozen_string_literal: true

module Homebank
  # Window shot configuration for an account
  class AccountWindow < Gtk::Window
    # Register the class in the GLib world
    type_register

    class << self
      def init
        # Set the template from the resources binary
        set_template resource: '/de/hofmann/homebank-gtk/ui/account_window.ui'
        # Bind the window's widgets
        %w[id_value_label bank_name_entry start_line_entry date_entry payment_entry tag_entry
           payee_entry memo_entry amount_entry category_entry notes_text_view
           cancel_button save_button delete_button].each do |widget|
          bind_template_child widget
        end
      end
    end

    def initialize(application, account)
      super(application:)

      init_account_window(account)
      # cancel
      cancel_button.signal_connect('clicked') { update_accounts(application) }
      # save
      save_button.signal_connect 'clicked' do
        save_account && update_accounts(application)
      end
      # delete
      delete_button.signal_connect 'clicked' do
        @account.delete! && update_accounts(application)
      end
      show
    end

    def update_accounts(application)
      application_window = application.windows.find { |w| w.is_a? ApplicationWindow }
      application_window.load_accounts
      application_window.present
      destroy
    end

    private

    def init_account_window
      @account = account
      account_title
      load_account unless @account.new?
    end

    def save_account
      init_account && @account.save!
    end

    def account_title
      set_title "Account #{@account.new? ? 'create' : 'edit'} mode"
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def load_account
      id_value_label.text = @account.id
      bank_name_entry.text = @account.bank_name
      start_line_entry.value = @account.start_line
      date_entry.value = @account.date
      payment_entry.value = @account.payment
      tag_entry.value = @account.tag
      payee_entry.value = @account.payee
      memo_entry.value = @account.memo
      amount_entry.value = @account.amount
      category_entry.value = @account.category
      notes_text_view.buffer.text = @account.notes || ''
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    # rubocop:disable Metrics/AbcSize
    def init_account
      @account.bank_name = bank_name_entry.text
      @account.start_line = start_line_entry.value_as_int
      @account.date = date_entry.value_as_int
      @account.payment = payment_entry.value_as_int
      @account.tag = tag_entry.value_as_int
      @account.payee = payee_entry.value_as_int
      @account.memo = memo_entry.value_as_int
      @account.amount = amount_entry.value_as_int
      @account.category = category_entry.value_as_int
      @account.notes = notes_text_view.buffer.text
    end
    # rubocop:enable Metrics/AbcSize
  end
end
