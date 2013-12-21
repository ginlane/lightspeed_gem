module LsRequests
  def ls_product
    VCR.use_cassette('single product') do
      Lightspeed::Product.find 3
    end
  end

  def ls_variant
    VCR.use_cassette('single variant') do
      Lightspeed::Product.find 88
    end
  end

  def ls_variants
    VCR.use_cassette('variant collection') do
      Lightspeed::Product.all(filters: {master_model_false: 1})
    end
  end

  def ls_products
    VCR.use_cassette('product master collection') do
      Lightspeed::Product.all(filters: {master_model_true: 1})
    end
  end

  def ls_invoices
    VCR.use_cassette('invoices') do
      Lightspeed::Invoice.all
    end
  end

  def ls_invoice
    VCR.use_cassette('invoice') do
      Lightspeed::Invoice.find 1
    end
  end

  def ls_line_items
    VCR.use_cassette('line_items') do
      Lightspeed::LineItem.all_for_invoice 1
    end
  end

  def ls_line_item
    ls_line_items.first
  end
end
