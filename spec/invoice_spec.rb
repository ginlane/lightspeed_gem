require 'spec_helper'

module Lightspeed
  describe Invoice do
    let(:singleton){ Invoice }
    let(:collection){ ls_invoices }

    context '#save' do
      let(:new_invoice){  singleton.new }

      context 'with attr changes' do
        it 'persists the changes' do
          new_invoice.create
          name = "Customer Z #{rand(9)}"
          new_invoice.invoice_customer = {mainname: name}
          new_invoice.save
          new_invoice.invoice_customer[:mainname].should == name
        end
      end
    end

    context '#create' do
      context 'with empty args' do
        it 'returns an instance' do
          i = singleton.new
          i.create
          i.id.should be_a(Integer)
        end
      end

      context 'with an attr hash' do
        it 'returns an instance' do
          i = singleton.new({invoice_status: 'Paid'})
          i.create
          i.invoice_status.should == 'Paid'
        end
      end
    end

    context '::all' do
      context 'w/ no filters' do
        it 'yields a collection' do
          collection.size.should > 1
          collection.first.should be_a(Invoice)
        end
      end
    end
  end
end
