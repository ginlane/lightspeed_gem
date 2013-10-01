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
end
