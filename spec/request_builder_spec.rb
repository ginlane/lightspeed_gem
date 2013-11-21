require 'spec_helper'

module Lightspeed
  describe RequestBuilder do
    let(:singleton){ RequestBuilder }

    context '#build' do
      context 'w/ attrs' do
        subject(:subject){ singleton.new(ls_invoice) }
        it 'includes attrs' do
          subject.request_body.should match(/Seb Bean/)
        end
      end

      context 'w/out attrs' do
        let(:subject){ singleton.new Invoice.new }

        it 'builds empty body' do
          subject.request_body.should == '<invoice/>'
        end
      end
    end
  end
end
