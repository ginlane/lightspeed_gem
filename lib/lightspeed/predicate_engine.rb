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
      :lteq => {:operator => '<=', :only => [:float, :integer]},
      :gt => {:operator => '>'},
      :gteq => {:operator => '>=', :only => [:float, :integer]},
      :cont => {:operator => 'CONTAINS[cd]', :only => [:string]},
      :not_cont => {:operator => 'CONTAINS[cd]', :compound => 'NOT', :only => [:string]},
      :start => {:operator => 'BEGINSWITH[cd]', :only => [:string]},
      :not_start => {:operator => 'BEGINSWITH[cd]', :compound => 'NOT', :only => [:string]},
      :end =>  {:operator => 'ENDSWITH[cd]', :only => [:string] },
      :not_end => {:operator => 'ENDSWITH[cd]', :compound => 'NOT', :only => [:string]},
      :true => {:operator => '==', :formatter => proc {|v| '1' }, :only => [:boolean]},
      :false => {:operator => '==', :formatter => proc {|v| '0' }, :only => [:boolean]},
      :null => {:operator => '==', :formatter => proc {|v| 'nil'}},
      :not_null => {:operator => '==', :formatter => proc {|v| 'nil'}, :compound => 'NOT'}
    }

    def initialize filterz
      self.filters = filterz
    end

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

    def validate_filter field, predicate, opts
      data_type = (
        refined = filters.select{|f| f[0] == field.to_sym} and
        filter = refined[0] and
        filter[1]
      )

      raise "Cannot use `#{predicate}` predicate on #{data_type} fields" if restriction = opts[:only] and !restriction.include? data_type
    end

    def add_filter field_cond, value
      field, predicate = separate_field_and_predicate field_cond.to_s
      opts = PREDICATE_TYPES[predicate.to_sym]
      formatter, compound, operator, types = opts.values_at(:formatter, :compound, :operator, :only)

      validate_filter field, predicate, opts
      
      converted_value = (formatter and formatter.call(value)) || infer_value_format(value, types)
      refinement = "#{field} #{operator} #{converted_value}"
      refinement = "#{compound} (#{refinement})" if compound

      self.compiled_predicates ||= []
      self.compiled_predicates << "(#{refinement})"
    end

    def infer_value_format v, types
      if (v.is_a? String) || (types == [:string])
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
