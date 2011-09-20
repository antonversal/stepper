require "stepper/exceptions"
require "stepper/model_steps"
require "stepper/controller_steps"

class << ActiveRecord::Base
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

    class_attribute :_stepper_steps
    self._stepper_steps= options[:steps]

    include Stepper::ModelSteps
  end
end

class << ActionController::Base
  def has_steps(options = {})
    #check options
    raise Stepper::StepperException.new("Options for has_steps must be in a hash.") unless options.is_a? Hash
    include Stepper::ControllerSteps
  end
end