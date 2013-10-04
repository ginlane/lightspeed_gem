module Lightspeed
  class Resource
    class << self
      attr_accessor :filters, :fields

      def all query = {}
        find_by_id(nil,  query)
      end

      def find_by_id id, query = {}
        resp = get(id, query).parsed_response
        data = resp[resource_name] || resp[resource_plural][resource_name]

        if id
          self.new data
        else
          data.map{|hash| self.new hash}
        end
      end
      alias :find :find_by_id

      def get command, opts
        Client.get full_path(command), {query: opts}
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
        next unless self.class.fields.include? k.to_s
        send("#{k}=", v)
      end
    end
  end
end
