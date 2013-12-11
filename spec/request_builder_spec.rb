require 'spec_helper'

module Lightspeed
  describe RequestBuilder do
    let(:singleton){ RequestBuilder }

    context '#build' do
      let(:doc){ Nokogiri::XML(subject.request_body) }

      context 'w/ attrs' do
        let(:subject){ singleton.new(ls_invoice) }

        it 'includes attrs' do
          doc.at_xpath('//invoice/invoice_customer/mainname').text.should == 'Seb Bean'
          doc.at_xpath('//invoice/tax_code').attr('id').should == '2'
          doc.at_xpath('//invoice/tax_code/id').should be_nil
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
