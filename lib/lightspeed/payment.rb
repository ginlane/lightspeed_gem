module Lightspeed
  class Payment < Resource

    class << self
      def all_for_invoice invoice_id
        all({:path_option => invoice_id})
      end

      def resource_path option
        "/invoices/#{option}/#{resource_plural}/"
      end
    end

    self.writable_fields = [
    ]
    self.readonly_fields = [
      :id,
      :uri,
      :type,
      :parent_id,
      :parent,
      :payment_method,
      :datetime_created,
      :datetime_modified,
      :exported,
      :posted,
      :flags,
      :number,
      :source,
      :amount,
      :tendered,
      :authcode,
      :avs_result,
      :till,
      :signature_photo
    ]

    self.fields = self.writable_fields + self.readonly_fields
    attr_accessor *self.fields

    alias :invoice_id :parent_id
  end
end
