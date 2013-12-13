module Lightspeed
  class RequestBuilder
    ATTR_FIELDS = [
      :id
    ]

    SKIP_FIELDS = [
      :uri,
      :full_render
    ]

    FORMATTED_FIELDS = {
      :datetime_created => lambda{|date| date.strftime("%FT%H:%M:%S.%6N") }
    }

    NESTED_ATTRIBUTE_FIELDS = {
      :tax => [:rate, :total],
      :discount => [:type],
      :pricing_level => [:index]
    }

    NESTED_ATTRIBUTE_FIELDS.default = []

    NESTED_NODES_TO_SKIP = {
      invoice: {
        flags: [:exported, :voided, :pay_backorders],
        print_options: [:images, :discounts],
        currency: [:name, :rate, :symbol]
      }
    }
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
      return if value.nil?
      if formatter = FORMATTED_FIELDS[field]
        doc.send(field, formatter.call(value))
      else
        doc.send(field, value)
      end
    end

    def add_nested_values doc, field, value
      attr_vals, nested_vals = partition_nested_values(field, value)

      doc.send(field, attr_vals) do
        nested_vals.each do |k,v|
          next if skip_nested_value?(field, k)
          add_values doc, k, v
        end
      end
    end

    def partition_nested_values field, hash
      attrs, nesteds = {}, {}
      hash.each do |k, v|
        if ATTR_FIELDS.include?(k) || NESTED_ATTRIBUTE_FIELDS[field].include?(k)
          attrs[k] = v
        elsif !SKIP_FIELDS.include? k
          nesteds[k] = v
        end
      end
      [attrs, nesteds]
    end

    def skip_nested_value? field, key
      NESTED_NODES_TO_SKIP[record_type] &&
      NESTED_NODES_TO_SKIP[record_type][field] &&
      NESTED_NODES_TO_SKIP[record_type][field].include?(key.to_sym)
    end

    def record_type
      record.class.name.to_s.downcase.gsub('lightspeed::', '').to_sym
    end

    def xml_doc
      build.doc
    end

    def request_body
      xml_doc.root.to_s
    end
  end
end
