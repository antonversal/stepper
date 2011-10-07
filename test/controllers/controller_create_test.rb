require "helper"
class CompaniesCreateControllerTest < ActionController::TestCase
  tests CompaniesController

  setup do
    Company.expects(:new).with({'name' => 'Hina'}).returns(mock_company)
    mock_company.expects(:attributes=).with({'name' => 'Hina'}).returns(true)
    mock_company.expects(:save).returns(true)
    mock_company.stubs(:id).returns(1)
  end

  test "should redirect to next step if commit 'Next step'" do
    mock_company.stubs(:stepper_current_step).returns("step1")
    post(:create, {:company => {:name => "Hina"}, :commit => "Next step"})
    assert_response :redirect
    assert_redirected_to "http://test.host/companies/1/next_step"
    assert_equal flash[:notice], "Step Step1 was successfully created."
  end

  test "should redirect to index if commit 'Finish later'" do
    post(:create, {:company => {:name => "Hina"}, :commit => "Finish later"})
    assert_response :redirect
    assert_redirected_to "http://test.host/companies"
  end

  protected
  def mock_company(stubs={})
    @mock_company ||= mock(stubs)
  end
end
