require 'helper'

class ControllerAdditionsTest < Test::Unit::TestCase
  context "assign" do
    setup do
      @controller_class = Class.new
      @controller = @controller_class.new
      @controller_class.send(:include, Stepper::ControllerAdditions)
    end

    should  "has_steps setup before filter which passes call to ControllerResource" do
      Stepper::ControllerResource.stubs(:new).with(@controller, nil).stubs(:load_resource)
      @controller_class.stubs(:before_filter).with(:only => [:create, :update, :new])
      @controller_class.has_steps
    end

  end

end