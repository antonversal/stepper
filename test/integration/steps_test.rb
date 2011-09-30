require 'helper'

class StepsTest < ActionController::IntegrationTest
  include Capybara::DSL

  test "fill all steps" do
    visit new_company_path
    fill_in "Name", :with => "My company"
    click_button "Next step"
    fill_in "Code", :with => "04108"
    click_button "Next step"
    fill_in "City", :with => "Kiev"
    click_button "Finish form"
    assert_equal page.current_path, company_path(Company.last)
  end


  test "previous step" do
    visit new_company_path
    fill_in "Name", :with => "My company"
    click_button "Next step"
    assert page.has_selector?('label', :text => 'Code')
    click_button "Previous step"
    assert page.has_selector?('label', :text => 'Name')
    assert page.has_selector?('#company_name', :value => 'My company')
    assert page.has_no_selector?('#error_explanation')
  end

  test "finish later" do
    visit new_company_path
    fill_in "Name", :with => "My company"
    click_button "Next step"
    assert page.has_selector?('label', :text => 'Code')
    click_button "Finish later"
    assert_equal page.current_path, companies_path
    assert page.has_no_selector?('#error_explanation')
  end

end