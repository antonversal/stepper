module Stepper
  module ControllerAdditions

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # Sets up +create+, +update+, +new+ actions for controller and before filter for load resource.
      # If you use cancan or load resource in other way it will get loaded resource.
      #
      # First parameters can be name of resource, for example:
      #
      #   class CompaniesController < ApplicationController
      #     has_steps :my_company
      #   end
      # It will load or build resource in +@my_company+ variable
      #
      # First argument it isn't required:
      #   class CompaniesController < ApplicationController
      #     has_steps
      #   end
      # In this case resource will be loaded or built into +@company+ variable
      def has_steps(*args)
        include InstanceMethods
        stepper_resource_class.add_before_filter(self, *args)
      end

      def stepper_resource_class
        ControllerResource
      end

    end

    module InstanceMethods

      # controller +create+ action
      # it supports only html responce format for now
      def create
        respond_to do |format|
          if @_stepper_resource_instance.save
            format.html { redirect_steps }
          else
            @_stepper_resource_instance.previous_step!
            format.html { render :action => "next_step" }
          end
        end
      end

      # controller +update+ action
      # it supports only html responce format for now
      def update
        @_stepper_resource_instance.previous_step!.previous_step! if params[:commit] == t('stepper.previous_step').html_safe

        @_stepper_resource_instance.previous_step! if params[:commit] == t('stepper.save').html_safe

        respond_to do |format|
          if @_stepper_resource_instance.save
            format.html { redirect_steps }
          else
            @_stepper_resource_instance.previous_step!
            format.html { render :action => "next_step" }
          end
        end
      end

      # controller +new+ action
      # it supports only html responce format for now
      def new

      end

      # controller +new+ action
      # it supports only html responce format for now
      def next_step
        if @_stepper_resource_instance.last_step?
          redirect_to :action => :show, :id => @_stepper_resource_instance.id
        else
          render :action => :new
        end
      end

      protected
        # redirects to controller actions depends of commit value
        #   save -> index
        #   previous_step -> new
        #   next_step -> new
        #   finish -> show
        def redirect_steps
          if params[:commit] == t('stepper.save').html_safe
            redirect_to :action => "index"
          elsif params[:commit] == t('stepper.previous_step').html_safe and params[:action] == "update"
            redirect_to :action => "next_step", :id => @_stepper_resource_instance.id
          elsif params[:commit] == t('stepper.next_step').html_safe
            redirect_to({:action => "next_step", :id => @_stepper_resource_instance.id}, :notice => "Step #{@_stepper_resource_instance.stepper_current_step.humanize} was successfully created.")
          elsif params[:commit] == t('stepper.finish').html_safe
            redirect_to :action => "show", :id => @_stepper_resource_instance.id
          else
            raise Stepper::StepperException.new("Unknown commit: #{params[:commit]}")
          end
        end

        # removes from params resource name, commit and id
        def sanitized_params
          params.except(@_stepper_name, :commit, :id)
        end
    end

  end

end