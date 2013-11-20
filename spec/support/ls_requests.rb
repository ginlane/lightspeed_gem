module LsRequests
  def ls_product
    VCR.use_cassette('single product') do
      singleton.find 3
    end
  end

  def ls_products
    VCR.use_cassette('product collection') do
      singleton.all
    end
  end

  def ls_invoices
    VCR.use_cassette('new_lightspeed_products') do
      singleton.all
    end
  end
end

