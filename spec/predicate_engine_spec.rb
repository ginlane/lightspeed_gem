require 'spec_helper'

describe Lightspeed::PredicateEngine do
  let(:singleton){ Lightspeed::PredicateEngine }
  
  context 'when building filters' do
    before do
      # sampled from Product model
      subject.filters = [
        [:code, :string, "Product Code"],
        [:cost, :float, "Default cost"],
        [:date_cre, :date, "Created Date (YYYY-MM-DD or M-DD-YYYY)"],
        [:current, :boolean, "Is product checked as a current item?"]
      ]
    end

    context 'with no filters set' do
      it 'throws an error' do
        subject.filters = nil
        lambda{ subject.add_filters(code_cont: 'VAL') }.should raise_error(/set filters/)
      end
    end

    context 'when validating query' do
      context 'on invalid field prefix' do
        it 'raises' do
          lambda{ subject.add_filters(cole_cont: 'VAL') }.should raise_error(/invalid filter field/i)
        end
      end

      context 'on invalid predicate suffix' do
        it 'raises' do
          lambda{ subject.add_filters(code_containss: 'VAL') }.should raise_error(/invalid filter predicate/i)
        end
      end

      context 'on a valid filter' do
        it 'correctly identifies field and predicate' do
          subject.separate_field_and_predicate('code_cont').should == ['code', 'cont']
        end

        context 'for floats' do
          context 'for `comparisons`' do
            it 'translates to NSPred form' do
              subject.add_filters(:cost_lteq => 55.6)
              subject.compiled_predicates.should == ['(cost <= 55.6)']
            end
          end
        end

        context 'for booleans' do
          context 'for `true` predicate' do
            it 'translates to NSPredicate form' do
              subject.add_filters(:current_true => true)
              subject.compiled_predicates.should == ['(current == TRUEPREDICATE)']
            end
          end

          context 'for `false` predicate' do
            it 'translates to NSPredicate form' do
              subject.add_filters(:current_false => 1)
              subject.compiled_predicates.should == ['(current == FALSEPREDICATE)']
            end
          end
        end

        context 'for strings' do
          context 'for `contains` predicate' do

            it 'translates to NSPredicate' do
              subject.add_filters(code_cont: 'VAL')
              subject.compiled_predicates.should == ['(code CONTAINS[cd] "VAL")']
            end

            it 'translatesi inverse to NSPredicate' do
              subject.add_filters(code_not_cont: 'VAL')
              subject.compiled_predicates.should == ['(NOT (code CONTAINS[cd] "VAL"))']
            end
          end

          context 'for `start` predicate' do

            it 'translates to NSPredicate' do
              subject.add_filters(code_start: 'BEG')
              subject.compiled_predicates.should == ['(code BEGINSWITH[cd] "BEG")']
            end

            it 'translates inverse to NSPredicate' do
              subject.add_filters(code_not_start: 'BEG')
              subject.compiled_predicates.should == ['(NOT (code BEGINSWITH[cd] "BEG"))']
            end
          end
        end
      end
    end
  end
  
end
