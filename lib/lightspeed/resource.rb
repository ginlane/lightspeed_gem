module Lightspeed
  class Resource
    class << self
      attr_accessor :filters, :fields
      QUERY_KEYS = [:count, :order_by, :filters]

      def all query = {}
        get(nil,  query)
      end

      def find_by_id id, query = {}
        get(id, query)
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

      def process_response! resp, opts, command = nil
        result = cast! resp
        result = result[resource_name.to_sym] || result[resource_plural.to_sym][resource_name.to_sym]

        if command 
          result = self.new result
        else
          result = [result] unless result.is_a? Array
          result = ResultArray.new(result.map{|r| self.new r}) 
          result.query = opts
          result.sort, result.order = parse_sort opts
        end

       result 
      end

      def process_options! opts
        validate opts
        add_default_scope! opts
        add_filters! opts
      end

      def get command, opts
        process_options! opts
        resp = Client.get(full_path(command), {query: opts}).parsed_response
        process_response! resp, opts, command
      end

      def add_default_scope! opts
        opts[:count] ||= 50
        opts[:order_by] ||= 'id:desc'
      end

      def add_filters! hash
        return unless query = hash.delete(:filters) and !query.empty?

        pe = PredicateEngine.new filters
        pe.add_filters query
        hash[:filter] = pe.compiled_predicates.join(' AND ')
      end

      def parse_sort opts
        return unless sort = opts[:order_by]

        sort.gsub!(' ',':')
        field, order = sort.split(/:/)[0..1]
        raise "Invalid field `#{field}` used for sort" unless filter_fields.include? field.to_sym
        raise "Invalid sort order `#{order}`" unless ['asc', 'desc'].include? order

        [field, order]
      end

      def validate opts
        opts.keys.each do |key|
          raise "Unsupported query key: #{key}." unless QUERY_KEYS.include? key.to_sym
        end

        parse_sort opts
      end

      def full_path suffix = nil
        result = "#{resource_path}#{suffix}" 
        result = "#{result}/" unless result[-1] == '/'
        result
      end

      def filter_fields
        filters && filters.map(&:first)
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
        setter = "#{k}="
        next unless respond_to?(setter)
        send(setter, v)
      end
    end
  end
end
