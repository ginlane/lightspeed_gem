require 'lightspeed'

describe Lightspeed::ResultArray do
  let(:customer_1){ Lightspeed::Customer.new(id: 11, homepage: 'b')}
  let(:customer_2){ Lightspeed::Customer.new(id: 12, homepage: 'a')}
  let(:customer_3){ Lightspeed::Customer.new(id: 13, homepage: 'c')}

  let(:instance){ Lightspeed::ResultArray.new }
  context 'on #pagination_query' do
    context 'with defaults' do
      before do
        instance.query = {order_by: 'id:desc', count: 2}
        instance.sort = 'id'
        instance.order = 'desc'
        instance << customer_3
        instance << customer_2
        instance << customer_1
      end

      context 'on #next_page_query' do 
        it 'generates the query' do
          h = instance.next_page_query
          h[:order_by].should == 'id:desc'
          h[:filters].should == {id_lt: 11}
        end
      end

      context 'on #prev_page_query' do 
        it 'generates the query' do
          h = instance.prev_page_query
          h[:order_by].should == 'id:desc'
          h[:filters].should == {id_gt: 13}
        end
      end
    end
    
    context 'with alternative sort' do
      before do
        instance.query = {order_by: 'homepage:asc', count: 2}
        instance.sort = 'homepage'
        instance.order = 'asc'
        instance << customer_2
        instance << customer_1
        instance << customer_3
      end

      context 'on #next_page_query' do 
        it 'generates the query' do
          h = instance.next_page_query
          h[:order_by].should == 'homepage:asc'
          h[:filters].should == {homepage_gt: 'c'}
        end
      end

      context 'on #prev_page_query' do 
        it 'generates the query' do
          h = instance.prev_page_query
          h[:order_by].should == 'homepage:asc'
          h[:filters].should == {homepage_lt: 'a'}
        end
      end
    end
  end 
end
