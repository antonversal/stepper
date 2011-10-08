require "helper"

class CompaniesUpdateControllerTest < ActionController::TestCase
  tests CompaniesController

  setup do
    Company.expects(:find).with('1').returns(mock_company)
    mock_company.expects(:attributes=).with({'code' => '23'}).returns(true)
    mock_company.expects(:save).returns(true)
    mock_company.stubs(:id).returns(1)
  end

  test "should redirect to next step if commit 'Next step'" do
    mock_company.stubs(:stepper_current_step).returns("step2")
    put(:update, {:company => {:code => "23"}, :commit => "Next step", :id => 1})
    assert_response :redirect
    assert_redirected_to "http://test.host/companies/1/next_step"
  end

  test "should redirect to index if commit 'Finish later'" do
    mock_company.stubs(:previous_step!)
    put(:update, {:company => {:code => "23"}, :commit => "Finish later", :id => 1})
    assert_response :redirect
    assert_redirected_to "http://test.host/companies"
  end

  test "should redirect to previous step if commit 'Previous step'" do
    mock_company.expects(:previous_step!).returns(mock_company).at_least(2)
    mock_company.stubs(:current_step).returns("step2")
    put(:update, {:company => {:code => "23"}, :commit => "Previous step", :id => 1})
    assert_response :redirect
    assert_redirected_to "http://test.host/companies/1/next_step"
  end

  test "should redirect to show if commit 'Finish form'" do
    put(:update, {:company => {:code => "23"}, :commit => "Finish form", :id => 1})
    assert_response :redirect
    assert_redirected_to "http://test.host/companies/1"
  end

  protected
  def mock_company(stubs={})
    @mock_company ||= mock(stubs)
  end
end