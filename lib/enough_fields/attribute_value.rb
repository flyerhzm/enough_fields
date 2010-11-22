module EnoughFields
  class AttributeValue
    attr_reader :klass, :field, :call_stack
    attr_writer :call_stack

    def initialize(value, klass, field, call_stack)
      @value = value
      @klass = klass
      @field = field
      @call_stack = call_stack
    end

    def to_value
      @value
    end

    def eql?( other )
    self.klass == other.klass &&
    self.field == other.field &&
    self.call_stack == other.call_stack
    end

    def hash
      self.klass.hash + self.field.hash + self.call_stack.hash
    end
  end
end