module EnoughFields
  class Attributes < ActiveSupport::HashWithIndifferentAccess
    class <<self
      attr_accessor :klass

      def build(klass, attributes)
        @klass = klass
        self[attributes]
      end

      def [](attributes)
        hash = super
        hash.each do |key, value|
          hash[ [@klass, key] ] = AttributeValue.new(value)
          Thread.current[:monit_hash][ [@klass, key] ] = [false, caller[4..-1]]
        end
        hash
      end
    end

    def [](key)
      Thread.current[:monit_hash][ [self.class.klass, key] ] = true
      super && super.is_a?(AttributeValue) ? super.to_value : super
    end
  end
end