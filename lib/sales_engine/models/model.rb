module SalesEngine
  module Models
    module Model
      def self.included(cls)
        Models.classes << cls

        cls.class_eval do
          def self.instances
            @instances ||= []
          end

          def self.add_instance(attributes = {})
            instances << instance = new(attributes)
            instance
          end

          def self.random
            instances.sample
          end

          def self.method_missing(method_name, *args, &block)
            dynamic_finder = DynamicFinder.new(method_name)

            if dynamic_finder.match?
              instances.send(dynamic_finder.finder_method) do |instance|
                ivar = "@#{dynamic_finder.attribute}"
                instance.instance_variable_get(ivar) == args.first
              end
            else
              super
            end
          end

          def initialize(attributes)
            attributes.each do |attribute_name, attribute_value|
              instance_variable_set("@#{attribute_name}", attribute_value)
            end
          end
        end
      end
    end
  end
end