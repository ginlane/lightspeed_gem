require 'spec_helper'

describe Lightspeed::Product do
  let(:singleton){ Lightspeed::Product }

  context '::add_filters!' do
    context 'with a valid filter' do
      it 'returns compiled NSPredicates' do
        singleton.add_filters!(filters: {sell_lt: 100})
      end
    end
  end

  context 'on nested setters' do
    let(:instance){ singleton.new }
    it 'sets cost=' do
      instance.cost = 555
      instance.cost.should == 555
    end

    it 'sets height=' do
      instance.height = 13
      instance.height.should == 13
    end

    it 'sets description_copy=' do
      instance.description_copy = 'informations'
      instance.description.should == 'informations'
    end
  end

  context 'on a full_render' do
    let(:p){ ls_variant }

    context 'on #color' do
      it 'returns the value from the product_info hash' do
        p.color.should be_present
        p.color.should == p.product_info[:color]
      end
    end

    context 'on #size' do
      it 'returns the value from the product_info hash' do
        p.size.should be_present
        p.size.should == p.product_info[:size]
      end
    end
  end

  context 'on a partial render' do
    let(:p){ ls_variants[0] }
    
    context 'on #color' do
      it 'infers value from :code' do
        p.color.should be_present
        p.code.should match(/#{p.color}/)
      end
    end

    context 'on #size' do
      it 'infers value from :code' do
        p.size.should be_present
        p.size.should match(/#{p.size}/)
      end
    end
  end
end
