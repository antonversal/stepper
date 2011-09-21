module Stepper
  module ControllerSteps
    def self.included(base)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def create
        @resource = resource_class.new(params[name_from_controller.to_sym])
        respond_to do |format|
          if @resource.save
            format.html { redirect_steps }
          end
        end
      end

      def update
        @resource = resource_class.find(params[:id])
        @resource.attributes = params[name_from_controller.to_sym]
        @resource.previous_step! if params[:commit] == previous_step_commit_str
        respond_to do |format|
          if @resource.save
            format.html { redirect_steps }
          end
        end
      end

      def next_step
        instance_variable_set "@#{name_from_controller}", resource_class.find(params[:id])
      end

      private
        def name_from_controller
          params[:controller].sub("Controller", "").underscore.split('/').last.singularize
        end

        def resource_class
          name_from_controller.to_s.camelize.constantize
        end

        def sanitized_params
          params.except(name_from_controller, :commit, :id)
        end

        def redirect_steps
          if params[:commit] == save_commit_str
            redirect_to url_for(sanitized_params.merge(:action => "index")), :notice => "Step #{@resource.current_step.humanize} was successfully created."
          elsif params[:commit] == previous_step_commit_str and params[:action] == "update"
            redirect_to url_for(sanitized_params.merge(:action => "next_step", :id => @resource.id))
          elsif params[:commit] == next_step_commit_str
            redirect_to url_for(sanitized_params.merge(:action => "next_step", :id => @resource.id))
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
    end
  end
end