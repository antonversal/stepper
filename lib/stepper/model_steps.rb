module Stepper
  module ModelSteps
    def self.included(base)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods

      def stepper_steps
        self.class._stepper_steps
      end

    end
  end
end