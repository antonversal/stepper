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
      #
      # You can setup redirection for each +save+, +previous_step+, +next_step+ and +finish+ step to other action than default,
      # options should have +after+ prefix:
      #
      #   class CompaniesController < ApplicationController
      #     has_steps :redirect_to => { :after_save => {:action => :new} }
      #   end
      #
      # You can set proc that will be executed for current controller:
      #
      #   class CompaniesController < ApplicationController
      #     has_steps :redirect_to => { :after_finish => proc{|controller, resource| controller.show_companies_url(resource)} }
      #   end

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
            format.html { render :action => "new" }
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
            format.html { render :action => "new" }
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

        # default redirection actions
        def default_redirection
          {
            :next_step      => {:action => "next_step", :id => @_stepper_resource_instance.id},
            :previous_step  => {:action => "next_step"},
            :save           => {:action => "index"},
            :finish         => {:action => "show", :id => @_stepper_resource_instance.id}
          }
        end

        # redirects to controller actions depends of commit value
        #   save -> index
        #   previous_step -> new
        #   next_step -> new
        #   finish -> show

        def redirect_steps
          options, response_status = redirect_steps_options
          redirect_to options, response_status
        end

        def redirect_steps_options
          case params[:commit]
            when t('stepper.save')
              [ extract_redirect_params(:save), {}]
            when t('stepper.previous_step')
              [ extract_redirect_params(:previous_step), {}]
            when t('stepper.next_step')
              [ extract_redirect_params(:next_step), {}]
            when t('stepper.finish')
              [ extract_redirect_params(:finish), {}]
            else
             raise Stepper::StepperException.new("Unknown commit: #{params[:commit]}")
          end
        end

        def extract_redirect_params(option)
          redirection = @_stepper_redirect_to["after_#{option.to_s}".to_sym]
          if redirection.is_a?(Proc)
            redirection.call(self, @_stepper_resource_instance)
          else
            redirection
          end || default_redirection[option]
        end

        # removes from params resource name, commit and id
        def sanitized_params
          params.except(@_stepper_name, :commit, :id)
        end
    end

  end

end