require 'spec_helper'

module Lightspeed
  describe Payment do
    let(:singleton){ Payment }

    context '#create' do
      let(:new_invoice){ Invoice.new.create }
      pending 'should set the :id' do
        p = new_invoice.build_payment
        p.create
        p.id.should be_a(Integer)
      end
    end
  end
end
