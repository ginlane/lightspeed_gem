require 'spec_helper'

describe Lightspeed::Resource do
  let(:singleton){ Lightspeed::Resource }

  context 'on ::resource_path' do
    it 'raises an abstract error' do
      lambda{
        singleton.resource_path
      }.should raise_error(/abstract/i)
    end
  end

  context 'on ::cast!' do
    it 'converts strings to booleans' do
      h = {a:  {b: 'false'}, c: ['true']}
      singleton.cast!(h)[:a][:b].should == false
      singleton.cast!(h)[:c].should == [true]
    end
  end

  context 'on ::validate' do
    before do
      singleton.fields = [:current, :date_cre]
    end

    context 'with a bad sort field' do
      it 'raises' do
        lambda{ singleton.validate({:order_by => 'bad asc'})}.should raise_error(/invalid field/i)
      end
    end

    context 'with a bad sort order' do
      it 'raises' do
        lambda{ singleton.validate({:order_by => 'current alpha'})}.should raise_error(/invalid sort/i)
      end
    end
  end

  context 'on ::add_filters' do
    before do
      singleton.fields = [:current, :sku]
      singleton.filters = [
        [:current, :boolean, 'Somee desc'],
        [:sku, :string, 'some more desc']
      ]
    end

    context 'for valid input' do
      it 'compiles and `AND` joins filters' do
        singleton.add_filters!(:current_true => '', :sku_start => 'BEG').should == '(current == TRUEPREDICATE) AND (sku BEGINSWITH[cd] "BEG")'
      end
    end
  end
end
