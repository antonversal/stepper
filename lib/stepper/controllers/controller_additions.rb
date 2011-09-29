module Stepper
  module ControllerAdditions

    def self.included(base)
      base.extend ClassMethods
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
          else
            @_stepper_resource_instance.previous_step!
            format.html { render :action => "new" }
          end
        end
      end

      def update
        @_stepper_resource_instance.previous_step! if params[:commit] == t('stepper.previous_step').html_safe
        respond_to do |format|
          if @_stepper_resource_instance.save
            format.html { redirect_steps }
          else
            @_stepper_resource_instance.previous_step!
            format.html { render :action => "new" }
          end
        end
      end

      def new
      end

      protected

        def redirect_steps
          if params[:commit] == t('stepper.save').html_safe
            redirect_to url_for(sanitized_params.merge(:action => "index")), :notice => "Step #{@_stepper_resource_instance.current_step.humanize} was successfully created."
          elsif params[:commit] == t('stepper.previous_step').html_safe and params[:action] == "update"
            redirect_to url_for(sanitized_params.merge(:action => "new", :id => @_stepper_resource_instance.id))
          elsif params[:commit] == t('stepper.next_step').html_safe
            redirect_to url_for(sanitized_params.merge(:action => "new", :id => @_stepper_resource_instance.id))
          else
            raise Stepper::StepperException.new("Unknown commit: #{params[:commit]}")
          end
        end

        def sanitized_params
          params.except(@_stepper_name, :commit, :id)
        end
    end

  end

end