module EnoughFields
  class MonitHash < Hash

    def check_notifications
      self.each do |klass_field, used_caller|
        klass, field = *klass_field
        used, call_stack = *used_caller
        unless used
          EnoughFields.add_notification(klass, field, call_stack)
        end
      end
    end
  end
end