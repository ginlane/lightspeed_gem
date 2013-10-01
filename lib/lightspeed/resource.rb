module Lightspeed
  class Resource
    class << self
      def all query = nil
        get nil, query
      end

      def find_by_id id, query = nil
        get id, query
      end

      def get command, query
        Client.get full_url(command), query
      end

      def full_url suffix
        result = "#{resource_path}#{suffix}" 
        result = "#{result}/" unless result.last == '/'
        result
      end

      def resource_path
        raise "Calling an abstract method! Use actual resource classes" if name == 'Lightspeed::Resource'
        "#{name.downcase}s/"
      end
    end  
  end
end
