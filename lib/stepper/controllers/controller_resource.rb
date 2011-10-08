module Stepper
  class ControllerResource
    # Sets up before filter in +controller_class+ for +create+, +update+, +new+ and +next_step+ actions.
    # First argument can be name of resource.
    # For example we have +CompaniesController+ and want to load or build resource to +@my_company+ variable:
    #   add_before_filter CompanyController, :my_company
    #
    # First argument it isn't required:
    #   add_before_filter CompanyController
    # In this case resource will be loaded or built into +@company+ variable
    #
    def self.add_before_filter(controller_class, *args)
      resource_name = args.first if args.first.is_a?(Symbol) or args.first.is_a?(String)
      options = args.extract_options!
      controller_class.send(:before_filter, :only => [:create, :update, :new, :next_step]) do |controller|
        controller.instance_variable_set :@_stepper_redirect_to, options[:redirect_to] || {}
        controller_resource = controller.class.stepper_resource_class.new(controller, resource_name)
        controller.instance_variable_set :@_stepper_resource_instance, controller_resource.load_resource
        controller.instance_variable_set :@_stepper_name, controller_resource.name
      end
    end

    def initialize(controller, *args)
      @controller = controller
      @params = controller.params
      @name = args.first
    end

    def load_resource
      self.resource_instance ||= load_resource_instance
      self.resource_instance.attributes = @params[name] unless @params[name].blank?
      self.resource_instance
    end

    def load_resource_instance
      if ['create', 'new'].include? @params[:action]
        resource = resource_class.new(@params[name] || {})
      else
        resource = unless @params[:id].blank?
          resource_class.find(@params[:id])
        else
          resource_class.new
        end
      end
      resource
    end

    def resource_class
      name.camelize.constantize
    end

    def name_from_controller
      @params[:controller].sub("Controller", "").underscore.split('/').last.singularize
    end

    def name
      @name || name_from_controller
    end

    def resource_instance=(object)
      @controller.instance_variable_set "@#{name}", object
    end

    def resource_instance
      @controller.instance_variable_get "@#{name}"
    end

  end
end