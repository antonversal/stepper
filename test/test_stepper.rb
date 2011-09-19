require 'helper'

class TestStepper < Test::Unit::TestCase

  context "ActiveRecord" do

    should "have method" do
      assert_respond_to ActiveRecord::Base, :has_steps
    end

    should "raise exception if options isn't hash" do
      assert_raise Stepper::StepperException do
        ActiveRecord::Base.has_steps "something"
      end
    end

    should "raise exception if options is wrong" do
      assert_raise Stepper::StepperException do
        ActiveRecord::Base.has_steps :some => "some", :steps => ["step1", "step2"]
      end
    end

    should "raise exception if options haven't :steps" do
      assert_raise Stepper::StepperException do
        ActiveRecord::Base.has_steps
      end
    end

  end

  context "has_steps method" do
    should "assign default column" do
      class Order < ActiveRecord::Base
        has_steps :steps => ["step1", "step2"]
      end
      assert_equal Order._stepper_current_step_column, :current_step
    end

    should "assign column from options" do
      class Order < ActiveRecord::Base
        has_steps :current_step_column => :my_step, :steps => ["step1", "step2"]
      end
      assert_equal Order._stepper_current_step_column, :my_step
    end

    should "assign default column" do
      class Order < ActiveRecord::Base
        has_steps :steps => ["step1", "step2"]
      end
      assert_equal Order._stepper_steps, ["step1", "step2"]
    end

  end

  context "class instance" do
    setup do
      class Order < ActiveRecord::Base
        has_steps :current_step_column => :my_step, :steps => ["step1", "step2", "step3"]
      end
    end
  end


end
