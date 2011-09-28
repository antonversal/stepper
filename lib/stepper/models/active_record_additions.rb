module Stepper
  module ActiveRecordAdditions

    def self.included(base)
      base.extend ClassMethods
      base.validate :current_step_validation
    end

    module ClassMethods
      def has_steps(options = {})
        #check options
        raise Stepper::StepperException.new("Options for has_steps must be in a hash.") unless options.is_a? Hash
        options.each do |key, value|
          unless [:current_step_column, :steps].include? key
            raise Stepper::StepperException.new("Unknown option for has_steps: #{key.inspect} => #{value.inspect}.")
          end
        end

        raise Stepper::StepperException.new(":steps condition can't be blank") if options[:steps].blank?

        #set current step column
        class_attribute :_stepper_current_step_column
        self._stepper_current_step_column = options[:current_step_column] || :current_step

        validates_presence_of self._stepper_current_step_column

        class_attribute :_stepper_steps
        self._stepper_steps= options[:steps]

        include InstanceMethods
      end
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
        self.send("#{self.class._stepper_current_step_column}=", step)
      end

      def last_step?(step = stepper_current_step)
        step == self.stepper_steps.last
      end

      def first_step?(step = stepper_current_step)
        (step == stepper_steps.first) or stepper_current_step.blank? && step.blank?
      end

      def previous_step
        return nil if (first_step? or stepper_current_step.blank?)
        stepper_steps[stepper_steps.index(stepper_current_step) - 1]
      end

      def previous_step!
        self.stepper_current_step = self.previous_step
      end

      def next_step
        return stepper_steps.first if self.stepper_current_step.blank?
        return nil if self.last_step?
        stepper_steps[stepper_steps.index(stepper_current_step) + 1]
      end

      def next_step!
        self.stepper_current_step = self.next_step
      end

      protected

        def current_step_validation
          return if stepper_current_step.blank?
          for i in 0..stepper_steps.index(stepper_current_step) do
            self.send("validate_#{stepper_steps[i]}") if self.respond_to?("validate_#{stepper_steps[i]}")
          end
        end

    end
  end
end
