require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock

   c.ignore_request do |request|
    URI(request.uri).path.match 'sessions/current/logout'
  end
end
