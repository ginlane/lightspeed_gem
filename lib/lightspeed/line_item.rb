module Lightspeed
  class LineItem < Resource
    class << self
      def all_for_invoice invoice_id
        all({:path_option => invoice_id})
      end

      def resource_path option
        "/invoices/#{option}/#{resource_plural}/"
      end
    end

    self.fields = [
      :id,
      :uri,
      :parent_id,
      :cost,
      :discount,
      :pricing_level,
      :ext_status,
      :profit_margin,
      :quantity,
      :quantity_backordered,
      :quantity_discount,
      :sell_price,
      :sells,
      :editable,
      :lineitem_product,
      :serial_numbers,
      :taxes
    ]

    attr_accessor *self.fields
    
    self.filters = [
      [:class_name, :string, "Class of line item"],
      [:code, :string, "Product Code"],
      [:cost, :float, "Cost of Goods"],
      [:current, :boolean, "is line item a current product?"],
      [:description, :string, "Description of line item"],
      [:discount, :string, "Discount (include % sign for percent discount, ex. '5%')"],
      [:editable, :boolean, "is description editable?"],
      [:editable_sell, :boolean, "is selling price editable?"],
      [:family, :string, "Family of line item"],
      [:gift_card, :boolean, "is line item a gift card?"],
      [:id, :integer, "Resource ID of line item"],
      [:inventoried, :boolean, "is line item an inventoried product?"],
      [:margin, :float, "Profit Margin"],
      [:min_margin, :float, "Minimum margin of line item"],
      [:no_profit, :boolean, "is cost equal to selling price?"],
      [:quantity, :float, "Quantity"],
      [:quantity_bo, :float, "Backordered quantity"],
      [:sell, :float, "Selling Price"],
      [:sell_base, :float, "Base Selling Price"],
      [:sell_total, :float, "Total Selling Price (sell * quantity)"],
      [:serialized, :boolean, "is line item a serialized product?"],
      [:tax_status, :string, "Tax status of line item"],
      [:tax1_total, :float, "Tax 1 total value"],
      [:tax2_total, :float, "Tax 2 total value"],
      [:tax3_total, :float, "Tax 3 total value"],
      [:tax4_total, :float, "Tax 4 total value"],
      [:tax5_total, :float, "Tax 5 total value"]
    ]

    alias :invoice_id :parent_id
  end
end
