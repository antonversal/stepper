module Stepper
  module ActionViewAdditions
    module InstanceMethods
      def stepper(form)
        resource = self.instance_variable_get :@_stepper_resource_instance
        current_step_column = resource.class._stepper_current_step_column
        self.render(:partial => "stepper/fields",
                    :locals => { :f => form,
                                 :resource => resource,
                                 :current_step_column => current_step_column }).to_s
      end
    end
  end
end