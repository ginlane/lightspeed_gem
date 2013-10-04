module Lightspeed
  class Resource
    class << self
      attr_accessor :filters

      def all query = {}
        get nil, query
      end

      def find_by_id id, query = {}
        get id, query
      end

      def get command, query
        Client.get full_path(command), query
      end

      def full_path suffix = nil
        result = "#{resource_path}#{suffix}" 
        result = "#{result}/" unless result[-1] == '/'
        result
      end

      def resource_path
        clazz = name.gsub("Lightspeed::",'')
        raise "Calling an abstract method! Use actual resource classes" if clazz == 'Resource'
        "/#{clazz.downcase}s/"
      end
    end  
  end
end
