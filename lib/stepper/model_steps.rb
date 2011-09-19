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

      def stepper_current_step
        self.send(self.class._stepper_current_step_column)
      end

      def stepper_current_step=(step)
        self.send(self.class._stepper_current_step_column, step)
      end

      def last_step?(step = self.stepper_current_step)
        step == self.stepper_steps.last
      end

      def first_step?(step = self.stepper_current_step)
        (step == stepper_steps.first) or stepper_current_step.blank? && step.blank?
      end

    end
  end
end