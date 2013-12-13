require 'spec_helper'


module Lightspeed
  describe LineItem do
    let(:singleton){ LineItem }
    let(:invoice){ ls_invoice }
    let(:line_items){ ls_line_items }
    let(:line_item){ ls_line_items[0] }
    let(:instance){ ls_line_item }

    context '::all' do
      it 'should raise' do
        lambda{ singleton.all }.should raise_error(/path_option/i)
      end
    end

    context '::all_for_invoice' do
      it 'should load related line_items' do
        line_items.should be_a(Array)
      end
    end

    context '::new' do
      it 'sets :parent_id from :uri' do
        line_item.parent_id.should be_a(Integer)
      end
    end

    context '#load' do
      it 'should load the resource details' do
        line_item.load
        line_item.quantity.should == 1
      end
    end

    context '#nested?' do
      it 'returns true' do
        line_item.nested?.should == true
      end
    end

    context '#default_opts' do
      it 'contains :path_option' do
        line_item.default_opts[:path_option].should be_a(Integer)
      end
    end
  end
end
