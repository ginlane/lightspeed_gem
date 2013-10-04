# Lightspeed

This gem exposes a Ransack-like predicate building syntax for querying Lightspeed. Additionally, it provides pagination API, sanitizes and type-csts returned values and provides a few helper methods for interacting with the data.

NOTE: Currently this gem supports read-only operations exclusively. 

## Installation

This is a private gem. As such you will need to clone it manually, like so:
```shell
git clone git@github.com:ginlane/lightspeed_gem.git
```

Build the gem and install it locally. For version 0.0.2, it would look like this:
```shell
gem build lightspeed.gemspec && gem install lightspeed-0.0.2.gem
```

## Usage
```ruby
require 'lightspeed'
Lightspeed::Client.config_from_yaml 'lightspeed.yml'

# Base querying methods for Customer model
Lightspeed::Customer.all(count: 10)
Lightspeed::Customer.find 7083

# Similarly for Invoice and Product
Lightspeed::Product.all(count: 2)
Lightspeed::Invoice.all(count: 2)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
