require 'spec_helper'

module Lightspeed
  describe Invoice do
    let(:singleton){ Invoice }

    context '::all' do
      context 'w/ no filters' do
        it 'yields a collection' do
          collection = VCR.use_cassette('new_lightspeed_products') do
            singleton.all
          end
          collection.size.should > 1
          collection.first.should be_a(Invoice)
        end
      end
    end
  end
end
