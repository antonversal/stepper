module Stepper
  module ActionViewAdditions
    module InstanceMethods
      def stepper(form)
        Stepper::Fields.new(self, form).to_s
      end
    end
  end
end