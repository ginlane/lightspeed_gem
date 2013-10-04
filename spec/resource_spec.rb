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
      h = {'a' => {'b' => 'false'}, 'c' => ['true']}
      singleton.cast!(h)['a']['b'].should == false
      singleton.cast!(h)['c'].should == [true]
    end
  end
end
