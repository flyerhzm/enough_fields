module EnoughFields
  class Attributes < ActiveSupport::HashWithIndifferentAccess
    class <<self
      attr_accessor :klass

      def build(klass, attributes)
        @klass = klass
        self[attributes]
      end

      def [](attributes)
        return super unless Thread.current[:monit_set]

        hash = super
        hash.each do |key, value|
          next if key.is_a? Array
          attribute_value = AttributeValue.new(value, @klass, key, caller[4..8])
          hash[ key ] = attribute_value
          Thread.current[:monit_set] << attribute_value
        end
        hash
      end
    end

    def [](key)
      return super unless Thread.current[:monit_set]

      if super && super.is_a?(AttributeValue)
        super.call_stack = nil
        super.to_value
      else
        super
      end
    end
  end
end