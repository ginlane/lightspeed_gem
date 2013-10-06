module Lightspeed
  class Resource
    class << self
      attr_accessor :filters, :fields
      QUERY_KEYS = [:count, :order_by, :filters]

      def all query = {}
        find_by_id(nil,  query)
      end

      def find_by_id id, query = {}
        resp = get(id, query)
        data = resp[resource_name.to_sym] || resp[resource_plural.to_sym][resource_name.to_sym]

        if id
          self.new data
        else
          data = [data] unless data.is_a? Array
          data.map{|hash| self.new hash}
        end
      end
      alias :find :find_by_id

      def cast! value
        case value
        when Array
          value.map{|item| cast! item}
        when Hash
          new_h = {}
          value.each do |k,v|
            new_h[k.to_sym] = cast! v
          end
          new_h
        when String
          cast_string! value
        else
          value
        end
      end

      def cast_string! value
        if value == 'false'
          false
        elsif value == 'true'
          true
        elsif value.match /\A\d+\z/
          value.to_i
        elsif value.match /\A\d+\.\d+\z/
          value.to_f
        elsif value.match /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/
          DateTime.parse value
        else
          value
        end
      end

      def get command, opts
        validate opts
        add_fiters! opts
        resp = Client.get full_path(command), {query: opts}
        cast!(resp.parsed_response)
      end

      def add_filters! hash
        pe = PredicateEngine.new filters
        pe.add_filters hash
        hash[:filters] = pe.compiled_predicates.join(' AND ')
      end

      def validate opts
        opts.keys.each do |key|
          raise "Unsupported query key: #{key}." unless QUERY_KEYS.include? key.to_sym
        end

        if sort = opts[:order_by]
          field, order = sort.split(/\s+/)[0..1]
          raise "Invalid field `#{field}` used for sort" unless fields.include? field.to_sym
          raise "Invalid sort order `#{order}`" unless ['asc', 'desc'].include? order.downcase
        end
      end

      def full_path suffix = nil
        result = "#{resource_path}#{suffix}" 
        result = "#{result}/" unless result[-1] == '/'
        result
      end

      def resource_class
        clazz = name.gsub("Lightspeed::",'')
        raise "Calling an abstract method! Use actual resource classes" if clazz == 'Resource'
        clazz
      end

      def resource_name
        resource_class.downcase
      end 

      def resource_plural
        "#{resource_name}s"
      end

      def resource_path
        "/#{resource_plural}/"
      end
    end

    def initialize hash
      hash.each do |k, v|
        next unless self.class.fields.include? k
        send("#{k}=", v)
      end
    end
  end
end
