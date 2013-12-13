require 'date'

require "httparty"
require "nokogiri"

require "lightspeed/version"
require "lightspeed/client"
require "lightspeed/predicate_engine"
require "lightspeed/request_builder"
require "lightspeed/result_array"

require "lightspeed/resource"
require "lightspeed/customer"
require "lightspeed/product"
require "lightspeed/invoice"
require "lightspeed/user"
require "lightspeed/class"
require "lightspeed/line_item"

HTTParty::Request::SupportedHTTPMethods.push(
  Net::HTTP::Lock,
  Net::HTTP::Unlock
)

module Lightspeed
end
