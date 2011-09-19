module Stepper
  module ModelSteps
    def self.included(base)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods

      def stepper_steps
        self.class._stepper_steps
      end

      alias_method(:steps, :stepper_steps) unless self.respond_to? :steps

    end
  end
end