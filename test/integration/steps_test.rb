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
  end

end