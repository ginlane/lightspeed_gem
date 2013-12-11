module LsRequests
  def ls_product
    VCR.use_cassette('single product') do
      Lightspeed::Product.find 3
    end
  end

  def ls_products
    VCR.use_cassette('product collection') do
      Lightspeed::Product.all
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
