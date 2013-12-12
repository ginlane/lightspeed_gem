require 'rspec'
require 'lightspeed'

require 'vcr_setup'
require 'support/ls_requests'

RSpec.configure do |config|
  config.before(:all) do
    Lightspeed::Client.config_from_yaml 'lightspeed.yml', :test
  end

  config.after(:suite) do |config|
    Lightspeed::Client.logout
  end

  config.include LsRequests
end
