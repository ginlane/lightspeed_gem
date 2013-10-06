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
      singleton.fields = [
        :current,
        :date_cre
      ]
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
end
