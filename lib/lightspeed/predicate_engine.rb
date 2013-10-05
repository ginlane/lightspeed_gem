require 'set'

module Lightspeed
  class PredicateEngine
    # Ideas on constant formation borrowed from https://github.com/ernie/ransack/blob/master/lib/ransack/constants.rb
    TRUE_VALUES = [true, 1, '1', 't', 'T', 'true', 'TRUE'].to_set
    FALSE_VALUES = [false, 0, '0', 'f', 'F', 'false', 'FALSE'].to_set

    PREDICATE_TYPES = %w(eq not_eq matches does_not_match lt lteq gt gteq in not_in)

    DERIVED_PREDICATES = [
      ['cont', {:ns_predicate => 'matches', :formatter => proc {|v| "%#{escape_wildcards(v)}%"}}],
      ['not_cont', {:ns_predicate => 'does_not_match', :formatter => proc {|v| "%#{escape_wildcards(v)}%"}}],
      ['start', {:ns_predicate => 'matches', :formatter => proc {|v| "#{escape_wildcards(v)}%"}}],
      ['not_start', {:ns_predicate => 'does_not_match', :formatter => proc {|v| "#{escape_wildcards(v)}%"}}],
      ['end', {:ns_predicate => 'matches', :formatter => proc {|v| "%#{escape_wildcards(v)}"}}],
      ['not_end', {:ns_predicate => 'does_not_match', :formatter => proc {|v| "%#{escape_wildcards(v)}"}}],
      ['true', {:ns_predicate => 'eq', :compounds => false, :type => :boolean, :validator => proc {|v| TRUE_VALUES.include?(v)}}],
      ['false', {:ns_predicate => 'eq', :compounds => false, :type => :boolean, :validator => proc {|v| TRUE_VALUES.include?(v)}, :formatter => proc {|v| !v}}],
      ['present', {:ns_predicate => 'not_eq_all', :compounds => false, :type => :boolean, :validator => proc {|v| TRUE_VALUES.include?(v)}, :formatter => proc {|v| [nil, '']}}],
      ['blank', {:ns_predicate => 'eq_any', :compounds => false, :type => :boolean, :validator => proc {|v| TRUE_VALUES.include?(v)}, :formatter => proc {|v| [nil, '']}}],
      ['null', {:ns_predicate => 'eq', :compounds => false, :type => :boolean, :validator => proc {|v| TRUE_VALUES.include?(v)}, :formatter => proc {|v| nil}}],
      ['not_null', {:ns_predicate => 'not_eq', :compounds => false, :type => :boolean, :validator => proc {|v| TRUE_VALUES.include?(v)}, :formatter => proc {|v| nil}}]
    ]
  end
end
