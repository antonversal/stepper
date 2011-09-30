require 'helper'
class ValidationModelTest < ActiveSupport::TestCase
  setup do
    @company = Company.new
  end

  test "should validate step1" do
    @company.my_step = "step1"
    assert !@company.save
    assert_equal @company.errors.messages, { :name=>["can't be blank"] }
  end

  should "validate step 3 and previous steps" do
    @company.my_step = "step3"
    assert !@company.save
    assert_equal @company.errors.messages, { :name => ["can't be blank"],
                                             :code => ["is not a number"],
                                             :city => ["can't be blank"] }
  end

  should "not run method if it doesn't exists" do
    class << @company
      undef_method :validate_step2
    end

    @company.name = "name"
    @company.city = "Kiev"
    @company.my_step = "step3"

    assert_nothing_raised NoMethodError do
      @company.save!
    end
  end


end
