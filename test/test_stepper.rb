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

  context "Company class instance" do
    setup do
      @order = Company.new
    end

    should "have steeper_steps methods" do
      assert_equal @order.stepper_steps, ["step1", "step2", "step3"]
    end

    should "have steps methods if steps method is free" do
      assert_equal @order.steps, ["step1", "step2", "step3"]
    end

    should "check step is first" do
      assert @order.first_step?("step1")
      assert !@order.first_step?("step3")
    end

    should "check step is last" do
      assert @order.last_step?("step3")
      assert !@order.last_step?("step1")
    end

    should "check step is first" do
      @order.my_step = "step1"
      assert @order.first_step?
      @order.my_step = "step3"
      assert !@order.first_step?
    end

    should "check current step is last" do
      @order.my_step = "step3"
      assert @order.last_step?
      @order.my_step = "step1"
      assert !@order.last_step?
    end

    should "return previous step" do
      assert_equal @order.previous_step, nil
      @order.my_step = "step1"
      assert_equal @order.previous_step, nil
      @order.my_step = "step2"
      assert_equal @order.previous_step, "step1"
    end

    should "return next step" do
      assert_equal @order.next_step, "step1"
      @order.my_step = "step2"
      assert_equal @order.next_step, "step3"
      @order.my_step = "step3"
      assert_equal @order.next_step, nil
    end

  end


end
