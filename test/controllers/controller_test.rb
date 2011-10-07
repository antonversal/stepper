require 'helper'

class CompaniesControllerTest < ActionController::TestCase
  tests CompaniesController

  test "should raise error if commit is unknown" do
    Company.expects(:new).with({'name' => 'Hina'}).returns(mock_company)
    mock_company.expects(:attributes=).with({'name' => 'Hina'}).returns(true)
    mock_company.expects(:save).returns(true)
    mock_company.stubs(:id).returns(1)
    assert_raise Stepper::StepperException do
      post(:create, {:company => {:name => "Hina"}, :commit => "some commit"})
    end
  end

  test "should assign resource if params[:id] exists" do
    @controller.stubs(:render)

    Company.expects(:find).with('1').returns(mock_company(:last_step? => false))
    get :next_step, :id => 1
    assert_response :success
    assert_equal assigns(:company), mock_company
  end

  test "should get existing assigns" do
    @controller.stubs(:render)
    @controller.instance_variable_set(:@company, mock_company(:last_step? => false))
    get :next_step, :id => 1
    assert_equal assigns(:company), mock_company
  end

  test "next_step action should redirect to show if company on at the last step" do
    @controller.instance_variable_set(:@company, mock_company(:last_step? => true, :id => "1"))
    get :next_step, :id => 1
    assert_response :redirect
    assert_redirected_to "http://test.host/companies/1"
  end

  protected
    def mock_company(stubs={})
      @mock_company ||= mock(stubs)
    end
end

