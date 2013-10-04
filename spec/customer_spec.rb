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

  context 'on ::new' do
    context 'w/ a valid hash' do
      it 'returns an instance' do
        h = {name: {first: "Bobby", last: "Tables"}}
        inst = singleton.new(h)
        inst.name[:first].should == 'Bobby'
      end
    end
  end

  # Instance methods below

  context 'for instances' do
    let(:instance) do
      Lightspeed::Customer.new(name: {first: 'Bobby', last: 'Tables'})
    end

    context 'on #first_ and #last_name' do
      it "interpolates datastore hash" do
        instance.first_name.should == 'Bobby'
        instance.last_name.should == 'Tables'
      end
    end
  end
end

