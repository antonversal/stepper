require 'helper'
class ActiveRecordTest < ActiveSupport::TestCase

  test "should have method" do
    assert_respond_to ActiveRecord::Base, :has_steps
  end

  test "should raise exception if options isn't hash" do
    assert_raise Stepper::StepperException do
      ActiveRecord::Base.has_steps "something"
    end
  end

  test "should raise exception if options is wrong" do
    assert_raise Stepper::StepperException do
      ActiveRecord::Base.has_steps :some => "some", :steps => ["step1", "step2"]
    end
  end

  test "should raise exception if options haven't :steps" do
    assert_raise Stepper::StepperException do
      ActiveRecord::Base.has_steps
    end
  end

end