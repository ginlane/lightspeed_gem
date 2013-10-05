require 'set'

module Lightspeed
  class PredicateEngine
    attr_accessor :filters, :compiled_predicates
    # Ideas on constant formation borrowed from https://github.com/ernie/ransack/blob/master/lib/ransack/constants.rb
    TRUE_VALUES = [true, 1, '1', 't', 'T', 'true', 'TRUE'].to_set
    FALSE_VALUES = [false, 0, '0', 'f', 'F', 'false', 'FALSE'].to_set

    PREDICATE_TYPES = {
      :eq => {:operator => '=='},
      :not_eq => {:operator => '<>'},
      :lt => {:operator => '<'},
      :lteq => {:operator => '<='},
      :gt => {:operator => '>'},
      :gteq => {:operator => '>='},
      :cont => {:operator => 'CONTAINS[cd]'},
      :not_cont => {:operator => 'CONTAINS[cd]', :compound => 'NOT'},
      :start => {:operator => 'BEGINSWITH[cd]'},
      :not_start => {:operator => 'BEGINSWITH[cd]', :compound => 'NOT'},
      :end =>  {:operator => 'ENDSWITH[cd]' },
      :not_end => {:operator => 'ENDSWITH[cd]', :compound => 'NOT'},
      :true => {:operator => '==', :formatter => proc {|v| 'TRUEPREDICATE'}},
      :false => {:operator => '==', :formatter => proc {|v| 'FALSEPREDICATE' }},
      :null => {:operator => '==', :formatter => proc {|v| 'nil'}},
      :not_null => {:operator => '==', :formatter => proc {|v| 'nil'}, :compound => 'NOT'}
    }

    def fields
      raise "Please set filters before building filter rules. Use #filters= " unless filters and !filters.empty?

      filters.map{|f| f[0] }
    end

    def add_filters hash
      return if hash.empty?

      hash.each do |field_cond, value|
        add_filter field_cond, value
      end
    end

    def add_filter field_cond, value
      field, predicate = separate_field_and_predicate field_cond.to_s
      opts = PREDICATE_TYPES[predicate.to_sym]
      formatter, compound, operator = opts.values_at(:formatter, :compound, :operator)

      converted_value = (formatter and formatter.call(value)) || format_typed_value(value)
      refinement = "#{field} #{operator} #{converted_value}"
      refinement = "#{compound} (#{refinement})" if compound

      self.compiled_predicates ||= []
      self.compiled_predicates << "(#{refinement})"
    end

    def format_typed_value v
      case v
      when String
        "\"#{v}\""
      else
        v
      end
    end

    def separate_field_and_predicate field_cond
      raise "Invalid filter field" unless field_cond.match(/^(#{fields.join('|')})_\w+/)
      raise "Invalid filter predicate" unless field_cond.match(/.+_(#{PREDICATE_TYPES.keys.join('|')})\z/)
      matches = field_cond.match(/^(#{fields.join('|')})_(#{PREDICATE_TYPES.keys.join('|')})$/)
      matches[1..2]
    end
  end
end
