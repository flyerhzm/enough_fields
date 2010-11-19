module EnoughFields
  class AttributeValue
    def initialize(value)
      @value = value
    end

    def to_value
      @value
    end
  end

  class MonitHash < Hash
  end

  class Attributes < ActiveSupport::HashWithIndifferentAccess
    def self.[](attributes)
      hash = super
      hash.each do |key, value|
        hash[key] = AttributeValue.new(value)
        Thread.current[:monit_hash][key] = [false, caller[4..-1]]
      end
      hash
    end

    def [](key)
      Thread.current[:monit_hash][key] = true
      super && super.is_a?(AttributeValue) ? super.to_value : super
    end
  end
end

module EnoughFields
  class <<self
    def enable
      Mongoid::Cursor.class_eval do
        def each
          @cursor.each do |document|
            attributes = Attributes[document]
            yield Mongoid::Factory.build(@klass, attributes)
          end
        end
      end

      Mongoid::Factory.class_eval do
        class <<self
          def build(klass, attributes)
            type = attributes["_type"]
            type ? type.constantize.instantiate(attributes) : klass.instantiate(attributes)
          end
        end
      end
    end
  end
end
