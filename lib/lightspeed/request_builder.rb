module Lightspeed
  class RequestBuilder
    ATTRIBUTE_FIELDS = [
      :uri,
      :inclusive,
      :id,
      :full_render
    ]

    NESTED_ATTRIBUTE_FIELDS = {
      :tax => [:rate, :total],
      :discount => [:type],
      :pricing_level => [:index]
    }
    NESTED_ATTRIBUTE_FIELDS.default = []

    attr_accessor :record

    def initialize objekt
      raise 'Please initialize with a Lightspeed::Resource' unless objekt.class.superclass == Resource
      self.record = objekt
    end

    def build
      Nokogiri::XML::Builder.new do |doc|
        doc.send(record.class.resource_name) do
          record.class.writable_fields.each do |field|
            next unless value = record.send(field)
            add_values doc, field, value
          end
        end
      end
    end

    def add_values doc, field, value
      if value.is_a? Hash
        add_nested_values doc, field, value
      else
        add_flat_value doc, field, value
      end
    end

    def add_flat_value doc, field, value
      doc.send(field, value)
    end

    def add_nested_values doc, field, value
      attrs, nesteds = value.partition do |k, v|
        ATTRIBUTE_FIELDS.include?(k) || NESTED_ATTRIBUTE_FIELDS[field].include?(k)
      end
      attr_vals, nested_vals = Hash[attrs], Hash[nesteds]

      doc.send(field, attr_vals) do
        nested_vals.each do |k,v|
          add_values doc, k, v
        end
      end
    end

    def xml_doc
      build.doc
    end

    def request_body
      xml_doc.root.to_s
    end
  end
end
