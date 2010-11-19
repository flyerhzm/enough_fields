require 'uniform_notifier'

module EnoughFields
  autoload :Rack, 'enough_fields/rack'
  autoload :AttributeValue, 'enough_fields/attribute_value'
  autoload :MonitHash, 'enough_fields/monit_hash'
  autoload :Attributes, 'enough_fields/attributes'

  if defined? Rails::Railtie
    class EnoughFieldsRailtie < Rails::Railtie
      initializer "enough_fields.configure_rails_initialization" do |app|
        app.middleware.use EnoughFields::Rack
      end
    end
  end

  class <<self
    delegate :alert=, :console=, :growl=, :rails_logger=, :xmpp=, :to => UniformNotifier

    def enable
      Mongoid::Cursor.class_eval do
        def each
          @cursor.each do |document|
            attributes = Attributes[document]
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

    def enough_fields_logger=(active)
      if active
        enough_fields_log_file = File.open( 'log/enough_fields.log', 'a+' )
        enough_fields_log_file.sync
        UniformNotifier.customized_logger = enough_fields_log_file
      end
    end

    def start_request
    end

    def end_request
    end

    def notification?
    end

    def gather_inline_notifications
      responses = []
      UniformNotifier.active_notifiers.each do |notfier|
        responses << notification.notify_inline(notifier)
      end
      responses.join( "\n" )
    end

    def perform_out_of_channel_notifications
      UniformNotifier.active_notifiers.each do |notfier|
        notfier.notify_out_of_channel(notifier)
      end
    end
  end
end
