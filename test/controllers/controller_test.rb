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
    assert_equal flash[:notice], "Step Step2 was successfully created."
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

class CompaniesInvalidParamsControllerTest < ActionController::TestCase
  tests CompaniesController

  setup do
    @controller.expects(:render).at_least_once
  end

  test "should create action render to new action if object.save returns false" do
    Company.expects(:new).with({'name' => 'Hina'}).returns(mock_company)
    mock_company.expects(:attributes=).with({'name' => 'Hina'}).returns(true)
    mock_company.expects(:save).returns(false)
    mock_company.expects(:previous_step!)
    post(:create, {:company => {:name => "Hina"}, :commit => "Next step"})
    assert_response :success
  end

  test "should update action redirect to new action if object.save returns false" do
    Company.expects(:find).with('1').returns(mock_company)
    mock_company.expects(:attributes=).with({"name" => "Hina"}).returns(true)
    mock_company.expects(:save).returns(false)
    mock_company.expects(:previous_step!)
    post(:update, {:company => {:name => "Hina"}, :id => 1, :commit => "Next step"})
    assert_response :success
  end

  protected
  def mock_company(stubs={})
    @mock_company ||= mock(stubs)
  end
end
