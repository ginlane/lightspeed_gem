module Lightspeed
  class Class < Resource
    
    class << self
      def resource_plural
        "#{resource_name}es"
      end
    end

    self.fields = [
      :name
    ]

    attr_accessor *self.fields

    self.filters = [
      [:id, :integer, "Resource ID"],
      [:classname, :string, "Name of class"]
    ]
  end
end
