module Stepper
  module ControllerSteps
    def self.included(base)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def create
        resource = resource_class.new(params[name_from_controller.to_sym])
        respond_to do |format|
          if resource.save
            format.html {
              if params[:commit] == "Finish later"
                redirect_to url_for(sanitized_params.merge(:action => "index")), :notice => "Step #{resource.current_step.humanize} was successfully created."
              else
                redirect_to url_for(sanitized_params.merge(:action => "next_step", :id => resource.id))
              end
            }
          end
        end
      end

      private
        def name_from_controller
          params[:controller].sub("Controller", "").underscore.split('/').last.singularize
        end

        def resource_class
          name_from_controller.to_s.camelize.constantize
        end

        def sanitized_params
          params.except(name_from_controller, :commit)
        end
    end
  end
end