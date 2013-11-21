require 'spec_helper'


module Lightspeed
  describe LineItem do
    let(:singleton){ LineItem }
    let(:ls_invoice){ ls_invoice }
    context '::all' do
      it 'should raise' do
        lambda{singleton.all}.should raise_error(/path_option/i)
      end
    end

    context '::all_for_invoice' do
      it 'should load related line_items' do
        lis = VCR.use_cassette('line_items') do
          Lightspeed::LineItem.all_for_invoice 1
        end

        lis.should_not be_empty
      end
    end
  end
end
