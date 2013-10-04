module Lightspeed
  class Invoice < Resource
    self.fields = ["datetime_created", "flags", "invoice_id", "invoice_customer", "totals", "uri", "id", "full_render"]

    attr_accessor *self.fields
  end
end
