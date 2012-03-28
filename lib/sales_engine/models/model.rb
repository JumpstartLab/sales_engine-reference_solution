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
                attribute_value = instance.send(dynamic_finder.attribute)
                Array(args.first).include?(attribute_value)
              end
            else
              super
            end
          end

          def initialize(attributes)
            attributes.each do |name, value|
              transformation = Transformation.new(name, value)
              instance_variable_set("@#{name}", transformation.transform)

              self.class.class_eval do
                define_method(name) { instance_variable_get("@#{name}") }
              end
            end
          end
        end
      end
    end
  end
end