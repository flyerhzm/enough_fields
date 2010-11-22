require 'set'

module EnoughFields
  class MonitSet < Set

    def check_notifications
      results = {}
      self.each do |attribute_value|
        if attribute_value.call_stack
          results[ [attribute_value.call_stack, attribute_value.klass] ] ||= []
          results[ [attribute_value.call_stack, attribute_value.klass] ] << attribute_value.field
        end
      end
      results.each do |call_stack_klass, fields|
        call_stack, klass = *call_stack_klass
        EnoughFields.add_notification(call_stack, klass, fields)
      end
    end
  end
end