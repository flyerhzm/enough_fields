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
          next if key.is_a?(Array) || [:_id, :_type].include?(key.to_sym)
          attribute_value = AttributeValue.new(value, @klass, key, caller.find_all { |c| c.index Rails.root })
          hash[ key ] = attribute_value
          Thread.current[:monit_set] << attribute_value
        end
        hash
      end
    end

    def [](key)
      return super unless Thread.current[:monit_set]

      if super && super.is_a?(AttributeValue)
        super.used = true
        super.to_value
      else
        super
      end
    end
  end
end