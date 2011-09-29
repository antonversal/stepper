require 'helper'
class AssignsModelTest < ActiveSupport::TestCase

  test "should assign default column" do
    assert_equal User._stepper_current_step_column, :current_step
  end

  test "should assign column from options" do
    assert_equal Company._stepper_current_step_column, :my_step
  end

  test "should assign default steps" do
    assert_equal Company._stepper_steps, ["step1", "step2", "step3"]
  end
end