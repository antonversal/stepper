require 'helper'
class InstanceModelTest < ActiveSupport::TestCase
  setup do
    @company = Company.new
  end

  test "should have steeper_steps methods" do
    assert_equal @company.stepper_steps, ["step1", "step2", "step3"]
  end

  test "should have steps methods if steps method is free" do
    assert_equal @company.steps, ["step1", "step2", "step3"]
  end

  test "should check step is first" do
    assert @company.first_step?("step1")
    assert !@company.first_step?("step3")
  end

  test "should check step is last" do
    assert @company.last_step?("step3")
    assert !@company.last_step?("step1")
  end

  test "should check current step is first" do
    @company.my_step = "step1"
    assert @company.first_step?
    @company.my_step = "step3"
    assert !@company.first_step?
  end

  test "should check current step is last" do
    @company.my_step = "step3"
    assert @company.last_step?
    @company.my_step = "step1"
    assert !@company.last_step?
  end

  test "should return previous step" do
    assert_equal @company.previous_step, nil
    @company.my_step = "step1"
    assert_equal @company.previous_step, nil
    @company.my_step = "step2"
    assert_equal @company.previous_step, "step1"
  end

  test "should return next step" do
    assert_equal @company.next_step, "step1"
    @company.my_step = "step2"
    assert_equal @company.next_step, "step3"
    @company.my_step = "step3"
    assert_equal @company.next_step, nil
  end

  test "should next_step! change step" do
    @company.next_step!
    assert_equal @company.my_step, "step1"
  end

  test "should previous_step! change step" do
    @company.my_step = "step3"
    @company.previous_step!
    assert_equal @company.my_step, "step2"
  end
end