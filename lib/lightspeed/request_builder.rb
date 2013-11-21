module Lightspeed
  class RequestBuilder

    READONLY_FIELDS = [
      :full_render,
      :uri,
      :datetime_created,
      :customer,
      :contact
    ]

    attr_accessor :record

    def initialize objekt
      raise 'Please initialize with a Lightspeed::Resource' unless objekt.class.superclass == Resource
      self.record = objekt
    end

    def build
      Nokogiri::XML::Builder.new do |doc|
        doc.send(record.class.resource_name) do
          record.class.fields.each do |field|
            next unless value = record.send(field)
            add_values doc, field, value
          end
        end
      end
    end

    def add_values doc, field, value
      return if READONLY_FIELDS.include? field

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
      doc.send(field) do
        value.each do |k,v|
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
