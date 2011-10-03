require 'helper'
class StiModelTest < ActiveSupport::TestCase
  setup do
    @big_company = BigCompany.new
  end

  test "should get steps from parent class" do
    assert_equal  @big_company.stepper_steps, ["step1", "step2", "step3", "step4", "step5", "step6"]
  end

end