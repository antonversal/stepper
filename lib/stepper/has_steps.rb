require 'stepper/exceptions'
class << ActiveRecord::Base
  def has_steps(options = {})
    #check options
    raise Stepper::StepperException.new("Options for has_steps must be in a hash.") unless options.is_a? Hash
    options.each do |key, value|
      unless [:current_step_column].include? key
        raise Stepper::StepperException.new("Unknown option for has_steps: #{key.inspect} => #{value.inspect}.")
      end
    end

    #set current step column
    class_attribute :_stepper_current_step_column
    self._stepper_current_step_column = options[:current_step_column] || :current_step
  end
end