# Lightspeed

This gem exposes a Ransack-like predicate building syntax for querying Lightspeed. Additionally, it provides pagination API, sanitizes and type-casts returned values and provides a few helper methods for interacting with the data.

NOTE: Currently this gem supports read-only operations exclusively. 

## Installation
```shell
gem install lightspeed
```

## Basic usage

Setting up credentials:
```ruby
require 'lightspeed'
Lightspeed::Client.config_from_yaml 'lightspeed.yml'
```

Base querying methods for Customer model
```ruby
Lightspeed::Customer.all
Lightspeed::Customer.find 7083 # same as ::find_by_id
```
Similarly for Invoice and Product
```ruby
Lightspeed::Product.all
Lightspeed::Invoice.all
```

## Querying
Ask singleton resource classes what filters they support
```ruby
Lightspeed::Product.filters
 => [[:class_name, :string, "Class"], [:code, :string, "Product Code"], [:cost, :float, "Default cost"], [:currency, :string, "Currency of default cost of product"], [:current, :boolean, "Is product checked as a current item?"], [:date_cre, :date, "Created Date (YYYY-MM-DD or M-DD-YYYY)"], [:date_mod, :date, "Modified Date (YYYY-MM-DD or M-DD-YYYY)"], [:datetime_cre, :datetime, "Created Date and Time (YYYY-MM-DD hh:mm:ss)"], [:datetime_mod, :datetime, "Modified Date and Time (YYYY-MM-DD hh:mm:ss)"], [:description, :string, "Product Description"], [:editable, :boolean, "Is product checked to have an editable description?"], [:editable_sell, :boolean, "Is product checked have an editable selling price?"], [:family, :string, "Family"], [:gift_card, :boolean, "Is product checked as a Gift Card?"], ... ]
```
Here are the available predicates (see the source in lib/lightspeed/predicate_engine.rb). Notice that partial string matching predicates are case- and diactric- incensitive:
```ruby
{
  :eq => {:operator => '=='},
  :not_eq => {:operator => '<>'},
  :lt => {:operator => '<'},
  :lteq => {:operator => '<=', :only => [:float, :integer]},
  :gt => {:operator => '>'},
  :gteq => {:operator => '>=', :only => [:float, :integer]},
  :cont => {:operator => 'CONTAINS[cd]', :only => [:string]},
  :not_cont => {:operator => 'CONTAINS[cd]', :compound => 'NOT', :only => [:string]},
  :start => {:operator => 'BEGINSWITH[cd]', :only => [:string]},
  :not_start => {:operator => 'BEGINSWITH[cd]', :compound => 'NOT', :only => [:string]},
  :end =>  {:operator => 'ENDSWITH[cd]', :only => [:string] },
  :not_end => {:operator => 'ENDSWITH[cd]', :compound => 'NOT', :only => [:string]},
  :true => {:operator => '==', :formatter => proc {|v| 'TRUEPREDICATE'}, :only => [:boolean]},
  :false => {:operator => '==', :formatter => proc {|v| 'FALSEPREDICATE' }, :only => [:boolean]},
  :null => {:operator => '==', :formatter => proc {|v| 'nil'}},
  :not_null => {:operator => '==', :formatter => proc {|v| 'nil'}, :compound => 'NOT'}
}
```

Gem builds queries following Ransack-like predicate hashes. For the following example we want to filter on ```:cost```, finding all products costing less than 100.00
```ruby
Lightspeed::Product.all(filters: {cost_lt: 100.0})
```

Predicates can be combined and will be joined with a logical AND like so:
```ruby
Lightspeed::Product.all(filters: {cost_lt: 100.0, description_cont: 'this string'})
```

## Faux-pagination
Lightspeed does not support pagination. A severely limited version of next/previous page functionality is implemented as prepared queries that can be request from the results collection.

Notice: if ```:count``` options is not specified, a default value of 50 is imposed.
```ruby
# Initial query
r = Lightspeed::Product.all(filters: {cost_lt: 100.0})
=> [#<Lightspeed::Product:0x00000000cfde88 @attr="value" ... ]
page2 = Lightspeed::Product.all(r.next_page_query)
```
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
