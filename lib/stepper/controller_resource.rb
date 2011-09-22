module Stepper
  class ControllerResource

    def self.add_before_filter(controller_class, *args)
      resource_name = args.first
      controller_class.send(:before_filter, :only => [:create, :update, :next_step]) do |controller|
        controller.class.stepper_resource_class.new(controller, resource_name).load_resource
      end
    end

    def initialize(controller, *args)
      @controller = controller
      @params = controller.params
      @name = args.first
    end

    def load_resource
      self.resource_instance ||= load_resource_instance
    end

    def load_resource_instance
      if @params[:action] == 'create'
        resource_class.new(@params[name] || {})
      else
        resource_class.find(@params[:id])
      end
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