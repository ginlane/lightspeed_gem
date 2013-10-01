require 'spec_helper'

describe Lightspeed::Client do
  let(:singleton){ Lightspeed::Client }
  
  context 'on ::new' do
    it 'accepts a hash and sets instance vars' do
      singleton.config_from_hash(:endpoint => 'something.tld', :username => 'bobby-tables', :password => 'lulsec')
      singleton.instance_variable_get(:@username).should == 'bobby-tables'
      singleton.instance_variable_get(:@endpoint).should == 'something.tld'
      singleton.instance_variable_get(:@password).should == 'lulsec'
    end
  end
end
