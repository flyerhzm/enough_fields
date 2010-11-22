require 'set'

module EnoughFields
  class Result
    attr_accessor :field, :used

    def initialize(field, used)
      @field = field
      @used = used
    end

    def used?
      used == true
    end
  end

  class MonitSet < Set

    def check_notifications
      results = {}
      self.each do |attribute_value|
        results[ [attribute_value.call_stack, attribute_value.klass] ] ||= []
        results[ [attribute_value.call_stack, attribute_value.klass] ] << Result.new(attribute_value.field, attribute_value.used?)
      end
      results.each do |call_stack_klass, results|
        call_stack, klass = *call_stack_klass
        if results.find { |result| !result.used? }
          EnoughFields.add_notification(call_stack, klass, results.find_all { |result| result.used? }.collect(&:field))
        end
      end
    end
  end
end