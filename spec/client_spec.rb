require 'spec_helper'

describe Lightspeed::Client do
  let(:singleton){ Lightspeed::Client }
  
  context 'on ::config_from_hash' do
    it 'accepts a hash and sets class vars' do
      singleton.config_from_hash(:endpoint => 'something.tld', :username => 'bobby-tables', :password => 'lulsec')
      singleton.instance_variable_get(:@username).should == 'bobby-tables'
      singleton.instance_variable_get(:@endpoint).should == 'something.tld'
      singleton.instance_variable_get(:@password).should == 'lulsec'
    end
  end

  context 'on ::config_from_yaml' do
    it 'accepts a file and sets class vars' do
      singleton.config_from_yaml('spec/example-config.yml')
      singleton.instance_variable_get(:@app_id).should == 'alpha123'
      singleton.instance_variable_get(:@endpoint).should == 'https://localhost:9966'
    end
  end
end
