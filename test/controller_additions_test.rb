require 'helper'

class ControllerAdditionsTest < Test::Unit::TestCase
  context "assign" do
    setup do
      @controller_class = Class.new
      @controller = @controller_class.new
      @controller_class.stubs(:helper_method).with(:save_commit_str, :next_step_commit_str, :previous_step_commit_str)
      @controller_class.send(:include, Stepper::ControllerAdditions)
    end

    should  "has_steps setup before filter which passes call to ControllerResource" do
      Stepper::ControllerResource.stubs(:new).with(@controller, nil).stubs(:load_resource)
      @controller_class.stubs(:before_filter).with(:only => [:create, :update, :next_step])
      @controller_class.has_steps
    end

  end

end