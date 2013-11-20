require 'spec_helper'

describe Lightspeed::Product do
  let(:singleton){ Lightspeed::Product }

  context '::add_filters!' do
    context 'with a valid filter' do
      it 'returns compiled NSPredicates' do
        singleton.add_filters!(filters: {sell_lt: 100})
      end
    end
  end
end
