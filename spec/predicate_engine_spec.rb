require 'spec_helper'

describe Lightspeed::PredicateEngine do
  let(:singleton){ Lightspeed::PredicateEngine }
  let(:instance) do
    Lightspeed::PredicateEngine.new  [
      [:code, :string, "Product Code"],
      [:cost, :float, "Default cost"],
      [:date_cre, :date, "Created Date (YYYY-MM-DD or M-DD-YYYY)"],
      [:current, :boolean, "Is product checked as a current item?"]
    ]
  end
  
  context 'when building filters' do
    context 'when validating query' do
      context 'on invalid field prefix' do
        it 'raises' do
          lambda{ instance.add_filters(cole_cont: 'VAL') }.should raise_error(/invalid filter field/i)
        end
      end

      context 'on invalid predicate suffix' do
        it 'raises' do
          lambda{ instance.add_filters(code_containss: 'VAL') }.should raise_error(/invalid filter predicate/i)
        end
      end

      context 'on a valid filter' do
        it 'correctly identifies field and predicate' do
          instance.separate_field_and_predicate('code_cont').should == ['code', 'cont']
        end

        context 'for floats' do
          context 'for `comparisons`' do
            it 'translates to NSPred form' do
              instance.add_filters(:cost_lteq => 55.6)
              instance.compiled_predicates.should == ['(cost <= 55.6)']
            end
          end
        end

        context 'for booleans' do
          context 'for `true` predicate' do
            it 'translates to NSPredicate form' do
              instance.add_filters(:current_true => true)
              instance.compiled_predicates.should == ['(current == TRUEPREDICATE)']
            end
          end

          context 'for `false` predicate' do
            it 'translates to NSPredicate form' do
              instance.add_filters(:current_false => 1)
              instance.compiled_predicates.should == ['(current == FALSEPREDICATE)']
            end
          end
        end

        context 'for strings' do
          context 'for `==` predicate' do
            it 'translates o NSPredicate' do
              instance.add_filters(code_eq: 'VAL')
              instance.compiled_predicates.should == ['(code == "VAL")']
            end
          end

          context 'for `contains` predicate' do
            it 'translates to NSPredicate' do
              instance.add_filters(code_cont: 'VAL')
              instance.compiled_predicates.should == ['(code CONTAINS[cd] "VAL")']
            end

            it 'translatesi inverse to NSPredicate' do
              instance.add_filters(code_not_cont: 'VAL')
              instance.compiled_predicates.should == ['(NOT (code CONTAINS[cd] "VAL"))']
            end
          end

          context 'for `start` predicate' do
            it 'translates to NSPredicate' do
              instance.add_filters(code_start: 'BEG')
              instance.compiled_predicates.should == ['(code BEGINSWITH[cd] "BEG")']
            end

            it 'translates inverse to NSPredicate' do
              instance.add_filters(code_not_start: 'BEG')
              instance.compiled_predicates.should == ['(NOT (code BEGINSWITH[cd] "BEG"))']
            end
          end
        end
      end
    end
  end
  
end
