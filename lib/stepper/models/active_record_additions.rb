module Stepper

  # This module is automatically included into all models.
  module ActiveRecordAdditions

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # Sets up methods and define steps.
      # For example, you have model +Company+ and you want to fill it fields in few steps description, kind and address:
      #   class Company < ActiveRecord::Base
      #     has_steps :steps => %w{ description kind address }
      #   end
      #
      # Model should have current step column, by default it name is +current_step+.
      # It should be added by migration:
      #   add_column :companies, :current_step, :string
      #   add_index  :companies, :current_step
      #
      # The column name can be set up with option +current_step_column+.
      #
      # Options:
      # [:+steps+]
      #   It is required option. Define steps for multistep form.
      #
      # [:+current_step_column+]
      #   Define what field use for save current step of form. Default +current_step+
      #

      def has_steps(options = {})
        #check options
        raise Stepper::StepperException.new("Options for has_steps must be in a hash.") unless options.is_a? Hash
        options.each do |key, value|
          unless [:current_step_column, :steps, :inherit].include? key
            raise Stepper::StepperException.new("Unknown option for has_steps: #{key.inspect} => #{value.inspect}.")
          end
        end

        raise Stepper::StepperException.new(":steps condition can't be blank") if options[:steps].blank?

        #set current step column
        class_attribute :_stepper_current_step_column
        self._stepper_current_step_column = options[:current_step_column] || :current_step

        class_attribute :_stepper_steps

        self._stepper_steps = []
        self._stepper_steps = self.try(:superclass).try(:_stepper_steps) if options[:inherit]
        self._stepper_steps += options[:steps]

        self.validate :current_step_validation

        include InstanceMethods
      end
    end

    module InstanceMethods

      # returns name of current step column
      def stepper_current_step_column
        self.class._stepper_current_step_column
      end

      # returns defined steps array
      def stepper_steps
        self.class._stepper_steps
      end

      alias_method(:steps, :stepper_steps) unless self.respond_to? :steps

      # returns index of current step in steps array
      def stepper_current_step_index
        stepper_steps.index(stepper_current_step)
      end

      # returns name of current step
      def stepper_current_step
        self.send(self.stepper_current_step_column)
      end

      alias_method :current_step, :stepper_current_step unless self.respond_to? :current_step

      # sets up name of current step
      # TODO: reject names that doesn't exists in steps array
      def stepper_current_step=(step)
        self.send("#{self.stepper_current_step_column}=", step)
      end

      alias_method :current_step=, :stepper_current_step= unless self.respond_to? :current_step=

      # Use to check current step or given step is last step
      #   last_step?("address")
      # TODO: reject names that doesn't exists in steps array
      def last_step?(step = stepper_current_step)
        step == self.stepper_steps.last
      end

      # Use to check current step or given step is first step
      #   first_step?("address")
      # TODO: reject names that doesn't exists in steps array
      def first_step?(step = stepper_current_step)
        (step == stepper_steps.first) or stepper_current_step.blank? && step.blank?
      end

      # returns previous step of current step
      def previous_step
        return nil if (first_step? or stepper_current_step.blank?)
        stepper_steps[stepper_steps.index(stepper_current_step) - 1]
      end

      # set previous step as current step
      def previous_step!
        self.stepper_current_step = self.previous_step
        self
      end

      # returns next step of current step
      def next_step
        return stepper_steps.first if self.stepper_current_step.blank?
        return nil if self.last_step?
        stepper_steps[stepper_steps.index(stepper_current_step) + 1]
      end

      # set next step as current step
      def next_step!
        self.stepper_current_step = self.next_step
        self
      end

      protected

        # Executes validation methods for current step and all previous steps if its exists.
        # You can set up what fields should be validated in methods for steps. For example:
        #
        # def validate_description
        #   self.validates_presence_of :name
        #   self.validates_presence_of :desc
        # end
        #
        # def validate_address
        #   self.validates_presence_of :city
        #   self.validates_presence_of :country
        #   self.validates_presence_of :address
        # end
        #
        # def validate_kind
        #   self.validates_presence_of :kind
        # end

        def current_step_validation
          return if stepper_current_step.blank?
          for i in 0..stepper_current_step_index do
            self.send("validate_#{stepper_steps[i]}") if self.respond_to?("validate_#{stepper_steps[i]}", true)
          end
        end

    end
  end
end
