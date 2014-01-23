module Lightspeed
  class Resource
    class << self
      attr_accessor :filters, :fields, :writable_fields, :readonly_fields
      QUERY_KEYS = [:count, :order_by, :filters, :path_option]

      def all query = {}
        raise ":path_option required when retriving nested resources" if self == LineItem and !query[:path_option]
        get(nil,  query)
      end

      def find_by_id id, query = {}
        raise "ID required when retrieving specific records!" unless id

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
        elsif value.match /\A\-?\d+\z/
          value.to_i
        elsif value.match /\A\-?\d+\.\d+\z/
          value.to_f
        elsif value.match /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/
          DateTime.parse value
        else
          value
        end
      end

      def process_response! resp, opts, command, verb
        result = cast! resp

        if result[:error]
          raise "Lightspeed server exception: #{result[:error][:type].gsub(/\W/, ' ')}\n#{result[:error][:traceback]}"
        end

        result = result[:response] || result
        result = result[resource_name.to_sym] || (result[resource_plural.to_sym] and result[resource_plural.to_sym][resource_name.to_sym])

        if command || verb != :get
          result && (result = self.new result)
        else
          return [] if result.nil?
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

      ['lock', 'unlock'].each do |verb|
        define_method(verb) do |id|
          Client.send(verb, full_path(id))
        end
      end

      def get command, opts
        path_option = opts.delete(:path_option)
        process_options! opts
        resp = Client.get(full_path(command, path_option), {query: opts}).parsed_response
        process_response! resp, opts, command, :get
      end

      def post command, body, opts = {}
        path_option = opts.delete(:path_option)
        resp = Client.post(full_path(command, path_option), :body => body).parsed_response
        process_response! resp, opts, command, :post
      end

      def put command, body, opts = {}
        path_option = opts.delete(:path_option)
        resp = Client.put(full_path(command, path_option), :body => body).parsed_response
        process_response! resp, opts, command, :put
      end

      def add_default_scope! opts
        return opts unless opts.empty?

        #opts[:count] = 50
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

      def full_path suffix = nil, option = nil
        result = "#{resource_path(option)}#{suffix}" 
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

      def resource_path option = nil
        "/#{resource_plural}/"
      end
    end

    def initialize hash = {}
      hash.each do |k, v|
        setter = "#{k}="
        alt_setter = "ls_#{k}="

        if respond_to?(setter)
          send(setter, v)
        elsif respond_to?(alt_setter)
          send(alt_setter, v)
        end
      end

      nested_initialize(hash)
    end

    def nested_initialize hash
      return unless nested?
      self.parent_id = uri.match(/\/api\/invoices\/(\d+)/)[1].to_i if uri
    end

    def memoize_output &block
      key = "@cached_#{caller(1,1)[0].gsub(/.+:in/, '').gsub(/\W/,'')}".to_sym
      existing_value = instance_variable_get(key)
      return existing_value if existing_value

      instance_variable_set(key, yield)
    end

    def lock!
      self.class.lock id
    end

    def unlock!
      self.class.unlock id
    end

    def guard_parent
      raise "Parent resource not set!" unless parent
    end

    def lock_parent!
      return unless nested?
      guard_parent
      parent.lock!
    end

    def unlock_parent!
      return unless nested?
      guard_parent
      parent.unlock!
    end

    def default_opts
      if nested?
        {:path_option => parent_id} 
      else
        {}
      end
    end

    def nested?
      respond_to? :parent_id
    end

    def load
      update_attrs_from_object(self.class.find id, default_opts)
    end

    def update_attrs_from_object objekt
      self.class.fields.each do |attr|
        next unless value = objekt.send(attr)
        self.send("#{attr}=", value)
      end

      self
    end

    def create
      raise "Record already has an :id. Use #create with new records strictly" if id

      lock_parent! if nested?
      send_creation
      unlock_parent! if nested?

      self
    end


    def save
      raise "Record needs to have an :id. Use #save with existing records only" unless id

      lock_parent! if nested?
      lock!
      send_updates
      unlock!
      unlock_parent! if nested?

      self
    end

    private

    def request_body
      RequestBuilder.new(self).request_body
    end

    def send_creation
      update_attrs_from_object(self.class.post(id, request_body, default_opts))
    end

    def send_updates
      update_attrs_from_object(self.class.put(id, request_body, default_opts))
    end
  end
end
