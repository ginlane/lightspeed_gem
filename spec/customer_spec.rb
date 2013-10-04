require 'spec_helper'

describe Lightspeed::Customer do
  let(:singleton){ Lightspeed::Customer }

  context 'on ::resource_path' do
    it 'returns \'customers/\'' do
      singleton.resource_path.should == '/customers/'
    end
  end

  context 'on ::full_path' do
    context 'with no args' do
      it 'returns base path' do
        singleton.full_path.should == '/customers/'
      end
    end

    context 'with an ID' do
      it 'returns a resource path' do
        singleton.full_path(31).should == '/customers/31/'
      end
    end
  end
end

