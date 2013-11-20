require 'rspec'
require 'lightspeed'

RSpec.configure do |config|
  config.before(:all) do
    Lightspeed::Client.config_from_yaml 'lightspeed.yml', :test
  end

  config.after(:all) do |config|
    Lightspeed::Client.logout
  end
end

