module EnoughFields
  class Notification
    attr_accessor :notifier

    def initialize(klass, field, call_stack)
      @klass = klass
      @field = field
      @call_stack = call_stack
    end

    def full_notice
      "#@klass##@field\n#@call_stack"
    end

    def notify_inline
      self.notifier.inline_notify( self.full_notice )
    end

    def notify_out_of_channel
      self.notifier.out_of_channel_notify( self.full_notice )
    end
  end
end