module Lightspeed
  class ResultArray < Array
    attr_accessor :query, :sort, :order

    def pagination_query inverse
      return {} if empty?

      filters = {}
      predicates = ['gt','lt']
      pred_i, val_i = case [order == 'desc', inverse]
      when [true, true]
        [0,0]
      when [true, false]
        [1,-1]
      when [false, true]
        [1,0]
      when [false, false]
        [0,-1]
      end
      {"#{sort}_#{predicates[pred_i]}".to_sym => self[val_i].send(sort)}
    end

    def merged_query inverse = false
      copy = query.dup
      filters = copy[:filters] || {}
      copy[:filters] = filters.merge(pagination_query inverse)
      copy
    end

    def next_page_query
      merged_query
    end

    def prev_page_query
      merged_query true
    end
  end
end
