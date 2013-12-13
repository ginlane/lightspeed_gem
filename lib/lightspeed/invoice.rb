module Lightspeed
  class Invoice < Resource
    self.writable_fields = [
      :datetime_created,
      :flags,
      :invoice_customer,
      :print_options,
      :primary_user,
      :secondary_user,
      :printed_notes,
      :internal_notes,
      :shipping_method,
      :currency,
      :terms,
      :cc_info,
      :tax_code,
      :pricing_level,
      :c_discount_percentage
    ]
    self.readonly_fields = [
      :document_id,
      :datetime_modified,
      :date_modified,
      :date_created,
      :invoice_id,
      :source,
      :invoice_id,
      :order,
      :margin,
      :returned_invoice,
      :due,
      :exported,
      :posted,
      :import_id,
      :invoice_status,
      :totals,
      :uri,
      :id,
      :full_render,
      :taxes,
      :station,
      :payments,
      :lineitems,
      :billing,
      :shipping
    ]

    self.fields = self.writable_fields + self.readonly_fields

    attr_accessor *self.fields
    
    self.filters = [
      [:age, :integer, "Age of the invoice (how many days has the status been owing)"],
      [:age_group, :string, " Age group of the invoice (ex. \"31 to 60 days\")"],
      [:cost_total, :float, "Total cost of items"],
      [:currency, :string, " Currency of invoice"],
      [:currency_rate, :float, "currency rate being charged"],
      [:date_cre, :date, " Created Date (YYYY-MM-DD or M-DD-YYYY)"],
      [:date_due, :date, " Due Date (YYYY-MM-DD or M-DD-YYYY)"],
      [:date_exported, :date, " Exported Date (YYYY-MM-DD or M-DD-YYYY)"],
      [:date_mod, :date, " Modified Date (YYYY-MM-DD or M-DD-YYYY)"],
      [:date_posted, :date, " Posted Date (YYYY-MM-DD or M-DD-YYYY)"],
      [:dropship, :boolean, "Is dropship checked?"],
      [:exported, :boolean, "Is invoice exported?"],
      [:id, :integer, "Resource ID"],
      [:internal_notes, :string, " Internal notes of invoice"],
      [:invoice_id, :string, " Invoice ID"],
      [:invoice_status, :string, " Status of invoice"],
      [:mainname, :string, " Customer/Walk in Name"],
      [:mainphone, :string, " Customer/Walk in phone number and type"],
      [:margin, :float, "Margin of sale"],
      [:pay_backorders, :boolean, "Is pay backorders checked?"],
      [:posted, :boolean, "Has the invoice been posted"],
      [:print_discounts, :boolean, "Is print discounts checked?"],
      [:print_images, :string, " Size that the images are set to be displayed in (ex. \"Medium\")"],
      [:print_language, :string, " Language that invoice should be printed in"],
      [:printed_notes, :string, " Printed notes"],
      [:sell_total, :float, "Total before tax"],
      [:shipping_method, :string, " Shipping method type"],
      [:source_id, :string, " Linked document ID"],
      [:station, :string, " Name of station where invoice was created"],
      [:subtotal, :float, "Subtotal (total before tax)"],
      [:total, :float, "Total after tax"],
      [:total_currency, :float, "Total after tax in default currency"],
      [:total_owing, :float, "Total amount owing"],
      [:total_owing_currency, :float, "Total amount owing in default currency"],
      [:total_paid, :float, "Total amount paid"],
      [:total_paid_currency, :float, "Total amount paid in default currency"],
      [:user, :string, " Primary user on invoice"],
      [:voided, :boolean, "Is invoice voided?"]
    ]

    def line_items
      @cached_line_items ||= LineItem.all_for_invoice id
    end
  end
end
