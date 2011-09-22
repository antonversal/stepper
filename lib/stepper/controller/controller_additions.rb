module Stepper
  module ControllerAdditions

    def self.included(base)
      base.extend ClassMethods
      base.helper_method :save_commit_str, :next_step_commit_str, :previous_step_commit_str
    end

    module ClassMethods
      def has_steps(*args)
        include InstanceMethods
        stepper_resource_class.add_before_filter(self, *args)
      end

      def stepper_resource_class
        ControllerResource
      end

    end

    module InstanceMethods

      def create
        respond_to do |format|
          if @_stepper_resource_instance.save
            format.html { redirect_steps }
          end
        end
      end

      def update
        @_stepper_resource_instance.previous_step! if params[:commit] == previous_step_commit_str
        respond_to do |format|
          if @_stepper_resource_instance.save
            format.html { redirect_steps }
          end
        end
      end

      def next_step
      end

      protected

        def redirect_steps
          if params[:commit] == save_commit_str
            redirect_to url_for(sanitized_params.merge(:action => "index")), :notice => "Step #{@_stepper_resource_instance.current_step.humanize} was successfully created."
          elsif params[:commit] == previous_step_commit_str and params[:action] == "update"
            redirect_to url_for(sanitized_params.merge(:action => "next_step", :id => @_stepper_resource_instance.id))
          elsif params[:commit] == next_step_commit_str
            redirect_to url_for(sanitized_params.merge(:action => "next_step", :id => @_stepper_resource_instance.id))
          else
            raise Stepper::StepperException.new("Unknown commit: #{params[:commit]}")
          end
        end

        def save_commit_str
          I18n.t(:save, :scope => 'stepper', :default => "Save")
        end

        def next_step_commit_str
          I18n.t(:next_step, :scope => 'stepper', :default => "Next")
        end

        def previous_step_commit_str
          I18n.t(:previous_step, :scope => 'stepper', :default => "Previous")
        end

        def sanitized_params
          params.except(@_stepper_name, :commit, :id)
        end
    end

  end

end


if defined? ActionController
  ActionController::Base.class_eval do
    include Stepper::ControllerAdditions
  end
end