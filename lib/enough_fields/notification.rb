module EnoughFields
  class Notification
    attr_accessor :notifier

    def initialize(call_stack, klass, fields)
      @call_stack = call_stack
      @klass = klass
      @fields = fields
    end

    def full_notice
      "add .only(#{(@klass.fields.keys - @fields).inspect}) for\n#{@call_stack.join("\n")}"
    end

    def notify_inline
      self.notifier.inline_notify( self.full_notice )
    end

    def notify_out_of_channel
      self.notifier.out_of_channel_notify( self.full_notice )
    end
  end
end