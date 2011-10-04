module Stepper
  module ActionViewAdditions
    module InstanceMethods
      # Render partial from app/views/stepper/_fields
      # Adds buttons "Next", "Previous", "Save" and "Finish" to form and adds hidden field with current step name.
      #
      # Add to locales for changing step names:
      #   en:
      #     stepper:
      #       next_step: 'Next step'
      #       previous_step: 'Previous step'
      #       save: 'Finish later'
      #       finish: 'Finish'
      #
      # +next_step+ button validates, saves current step and renders next step of form;
      # +previous_step+ saves current step and renders previous step of form;
      # +save+ save current step and redirects to index page;
      # +finish+ is showed only for last step instead of +next_step+ button and it validates, saves last step and redirects to show.
      #
      # If you want to have other partial for buttons than add partial to: +app/views/stepper/_fields.html.erb+
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