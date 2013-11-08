module Lightspeed
  class Product < Resource
    class << self
      def all_master_records
        all(filters: {master_model_true: ''})
      end
    end

    def master?
      flags && flags[:master_model]
    end

    def cost
      costs && costs[:cost]
    end

    def description_copy
      if full_render
        long_web_description ||
          (description && description[:__content__])
      else
        description
      end
    end

    def category_name
      return unless full_render

      memoize_output do 
        ls_class[:id] && Class.find(ls_class[:id]).name
      end
    end

    def color
      product_info && product_info[:color]
    end

    def height
      product_info && product_info[:height]
    end

    def length
      product_info && product_info[:length]
    end

    def size
      product_info && product_info[:size]
    end

    def weight
      product_info && product_info[:weight]
    end

    def width
      product_info && product_info[:width]
    end

    def full_variants
      memoize_output do
        variants.map(&:load)
      end
    end

    def variants
      memoize_output do
        Product.all(filters: {master_model_false: true, code_start: code})
      end
    end

    self.fields = [
      :ls_class,
      :currency,
      :code,
      :costs,
      :flags,
      :sell_price,
      :pricing_levels,
      :created,
      :modified,
      :description,
      :long_web_description,
      :family,
      :gl_product,
      :product_id,
      :import_id,
      :inventory,
      :margin,
      :minimum_margin,
      :notes,
      :product_info,
      :reorder,
      :sells,
      :supplier,
      :supplier_code,
      :upc,
      :web,
      :keywords,
      :multi_store_label,
      :multi_store_master_label,
      :categories,
      :related_products,
      :serial_numbers,
      :product_photos,
      :uri,
      :id,
      :full_render
    ]

    attr_accessor *self.fields

    self.filters = [
      [:class_name, :string, "Class"],
      [:code, :string, "Product Code"],
      [:cost, :float, "Default cost"],
      [:currency, :string, "Currency of default cost of product"],
      [:current, :boolean, "Is product checked as a current item?"],
      [:date_cre, :date, "Created Date (YYYY-MM-DD or M-DD-YYYY)"],
      [:date_mod, :date, "Modified Date (YYYY-MM-DD or M-DD-YYYY)"],
      [:datetime_cre, :datetime, "Created Date and Time (YYYY-MM-DD hh:mm:ss)"],
      [:datetime_mod, :datetime, "Modified Date and Time (YYYY-MM-DD hh:mm:ss)"],
      [:description, :string, "Product Description"],
      [:editable, :boolean, "Is product checked to have an editable description?"],
      [:editable_sell, :boolean, "Is product checked have an editable selling price?"],
      [:family, :string, "Family"],
      [:gift_card, :boolean, "Is product checked as a Gift Card?"],
      [:gl_inventory_asset, :string, "Inventory/Asset GL account"],
      [:gl_product_cogs_expense, :string, "COGS/Expense GL account"],
      [:gl_product_income, :string, "Income GL account"],
      [:gl_product_payable_expense, :string, "Payable expense GL account"],
      [:id, :integer, "Resource ID"],
      [:inventoried, :boolean, "Is product an inventoried item?"],
      [:long_web_description, :string, "Web long description"],
      [:margin, :float, "Margin"],
      [:master_model, :boolean, "Is product a matrix master product?"],
      [:min_margin, :float, "Minimum margin"],
      [:multi_store_label, :string, "Multi store label value"],
      [:new_import, :boolean, "Is product newly imported via import tool?"],
      [:new_update, :boolean, "Is product newly updated via import tool?"],
      [:no_live_rules, :boolean, "Can live rules be applied to product?"],
      [:no_profit, :boolean, "Cost always equal sell?"],
      [:notes, :string, "Notes"],
      [:product_color, :string, "Color of product"],
      [:product_height, :float, "Height of product"],
      [:product_id, :string, "Product ID, formatted as 'P-Integer'"],
      [:product_length, :float, "Length of product"],
      [:product_size, :string, "Size of product"],
      [:product_weight, :float, "Weight of product"],
      [:product_width, :float, "Width of product"],
      [:reorder_amt, :float, "Reorder amount"],
      [:reorder_point, :float, "Reorder point"],
      [:sell, :float, "Selling price"],
      [:sell_tax_inclusive, :float, "Tax inclusive selling price"],
      [:sell_web, :float, "Web Price"],
      [:serialized, :boolean, "Is product serialized / require serial numbers?"],
      [:supplier, :string, "Name of supplier"],
      [:supplier_code, :string, "Supplier Code"],
      [:upc, :string, "UPC code of product"],
      [:web, :boolean, "Is product checked to sell on webstore?"]
    ]

    alias_method :sku, :code
    alias_method :price, :sell_price
  end
end
