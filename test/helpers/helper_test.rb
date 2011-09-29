require 'helper'

class StepperButtonsTest < ActionController::IntegrationTest
  test "first step should have 'finish later' and 'next step' buttons" do
    get new_company_path
    assert_select "li.next_step" do
      assert_select "input[value='Next step']"
    end
    assert_select "li.save" do
      assert_select "input[value='Finish later']"
    end
    assert_select "li.previous_step", false, "This page must contain no previous button"
  end

  test "second step should have 'finish later', 'previous step' and 'next step' buttons" do
    company = Company.create!(:name => "My company", :my_step => "step1")
    get new_company_path(:id => company.id)

    assert_select "li.next_step" do
      assert_select "input[value='Next step']"
    end

    assert_select "li.save" do
      assert_select "input[value='Finish later']"
    end

    assert_select "li.previous_step" do
      assert_select "input[value='Previous step']"
    end
  end

  test "last step should have 'finish later', 'previous step' and 'finish' buttons" do
    company = Company.create!(:name => "My company", :code => "04108", :my_step => "step2")
    get new_company_path(:id => company.id)

    assert_select "li.finish" do
      assert_select "input[value='Finish form']"
    end

    assert_select "li.save" do
      assert_select "input[value='Finish later']"
    end

    assert_select "li.previous_step" do
      assert_select "input[value='Previous step']"
    end
  end

end