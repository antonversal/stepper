module Stepper
  module ActionViewAdditions
    module InstanceMethods
      def stepper(form)
        self.render :partial => "stepper/fields", :locals => {:f => form}
      end
    end
  end
end

ActionView::Base.send :include, Stepper::ActionViewAdditions::InstanceMethods