module EnoughFields
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