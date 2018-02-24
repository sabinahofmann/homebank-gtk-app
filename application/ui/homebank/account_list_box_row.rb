module Homebank
  class AccountListBoxRow < Gtk::ListBoxRow
    type_register

    class << self
      def init
        set_template resource: '/de/hofmann/homebank-gtk/ui/account_list_box_row.ui'
      end
    end

    def initialize(item)
      super()
    end
  end
end
