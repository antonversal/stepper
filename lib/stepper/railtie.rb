require 'rails'

require 'stepper/engine'
require 'stepper/controllers/controller_additions'
require 'stepper/controllers/controller_resource'
require 'stepper/exceptions'
require 'stepper/models/active_record_additions'
require 'stepper/helper/action_view_additions'

module Stepper
  class Railtie < ::Rails::Railtie #:nodoc:
    initializer 'stepper' do |app|
      ActiveSupport.on_load(:active_record) do
        ::ActiveRecord::Base.send :include, Stepper::ActiveRecordAdditions
      end

      ActiveSupport.on_load(:action_controller) do
        ::ActionController::Base.send :include, Stepper::ControllerAdditions
      end

      ActiveSupport.on_load(:action_view) do
        ::ActionView::Base.send :include, Stepper::ActionViewAdditions
      end
    end
  end
end
