require 'spec_helper'

module Lightspeed
  describe Invoice do
    let(:singleton){ Invoice }
    let(:collection){ ls_invoices }

    context '::all' do
      context 'w/ no filters' do
        it 'yields a collection' do
          collection.size.should > 1
          collection.first.should be_a(Invoice)
        end
      end
    end
  end
end
