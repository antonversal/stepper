require 'action_view/context'

module Stepper
  class Fields
    include ActionView::Context

    def initialize(template, form)
      @template = template
      @form = form
    end

    def to_s
      @template.render :partial => "stepper/fields", :locals => {:f => @form}
    end
  end
end