require 'uniform_notifier'

module EnoughFields
  autoload :Rack, 'enough_fields/rack'
  autoload :AttributeValue, 'enough_fields/attribute_value'
  autoload :Notification, 'enough_fields/notification'
  autoload :Attributes, 'enough_fields/attributes'
  autoload :MonitSet, 'enough_fields/monit_set'

  if defined? Rails::Railtie
    class EnoughFieldsRailtie < Rails::Railtie
      initializer "enough_fields.configure_rails_initialization" do |app|
        app.middleware.use EnoughFields::Rack
      end
    end
  end

  class <<self
    attr_accessor :disable_browser_cache
    delegate :alert=, :console=, :growl=, :rails_logger=, :xmpp=, :to => UniformNotifier

    def enable=(enable)
      @enable = enable
      if enable?
        Mongoid::Cursor.class_eval do
          alias_method :origin_each, :each

          def each
            @cursor.each do |document|
              attributes = Attributes.build(@klass, document)
              yield Mongoid::Factory.build(@klass, attributes)
            end
          end
        end

        Mongoid::Factory.class_eval do
          class <<self
            def build(klass, attributes)
              type = attributes["_type"]
              type ? type.constantize.instantiate(attributes) : klass.instantiate(attributes)
            end
          end
        end
      end
    end

    def enable?
      @enable == true
    end

    def enough_fields_logger=(active)
      if active
        enough_fields_log_file = File.open( 'log/enough_fields.log', 'a+' )
        enough_fields_log_file.sync
        UniformNotifier.customized_logger = enough_fields_log_file
      end
    end

    def start_request
      Thread.current[:monit_set] = MonitSet.new
    end

    def end_request
      Thread.current[:monit_set] = nil
      @notifications = nil
    end

    def notification?
      current_monit_set.check_notifications
      !notifications.empty?
    end

    def add_notification(call_stack, klass, fields)
      notification = Notification.new(call_stack, klass, fields)
      notifications << notification
    end

    def gather_inline_notifications
      responses = []
      for_each_active_notifier_with_notification do |notification|
        responses << notification.notify_inline
      end
      responses.join( "\n" )
    end

    def perform_out_of_channel_notifications
      for_each_active_notifier_with_notification do |notification|
        notification.notify_out_of_channel
      end
    end

    private
      def current_monit_set
        Thread.current[:monit_set]
      end

      def notifications
        @notifications ||= []
      end

      def for_each_active_notifier_with_notification
        UniformNotifier.active_notifiers.each do |notifier|
          notifications.each do |notification|
            notification.notifier = notifier
            yield notification
          end
        end
      end

  end
end
