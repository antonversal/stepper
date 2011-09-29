require 'helper'

class CompaniesControllerTest < ActionController::TestCase
  tests CompaniesController

  def test_raise_error_if_commit_is_unknown
    Company.expects(:new).with({'name' => 'Hina'}).returns(mock_company)
    mock_company.expects(:save).returns(true)
    mock_company.stubs(:id).returns(1)
    assert_raise Stepper::StepperException do
      post(:create, {:company => {:name => "Hina"}, :commit => "some commit"})
    end
  end

  def test_next_step
    Company.expects(:find).with('1').returns(mock_company)
    get :new, :id => 1
    assert_response :success
    assert_equal assigns(:company), mock_company
  end

  def test_getting_existing_assigns
    @controller.instance_variable_set(:@company, mock_company)
    get :new, :id => 1
    assert_equal assigns(:company), mock_company
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
    mock_company.expects(:save).returns(true)
    mock_company.stubs(:id).returns(1)
  end

  def test_next_step
    post(:create, {:company => {:name => "Hina"}, :commit => "Next step"})
    assert_response :redirect
    assert_redirected_to "http://test.host/companies/new?id=1"
  end

  def test_finish_later
    mock_company.stubs(:current_step).returns("step1")
    post(:create, {:company => {:name => "Hina"}, :commit => "Finish later"})
    assert_response :redirect
    assert_equal flash[:notice], "Step Step1 was successfully created."
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

  def test_next_step
    put(:update, {:company => {:code => "23"}, :commit => "Next step", :id => 1})
    assert_response :redirect
    assert_redirected_to "http://test.host/companies/new?id=1"
  end

  def test_finish_later
    mock_company.stubs(:current_step).returns("step2")
    put(:update, {:company => {:code => "23"}, :commit => "Finish later", :id => 1})
    assert_response :redirect
    assert_equal flash[:notice], "Step Step2 was successfully created."
    assert_redirected_to "http://test.host/companies"
  end

  def test_previous_step
    mock_company.expects(:previous_step!)
    mock_company.stubs(:current_step).returns("step2")
    put(:update, {:company => {:code => "23"}, :commit => "Previous step", :id => 1})
    assert_response :redirect
    assert_redirected_to "http://test.host/companies/new?id=1"
  end

  protected
  def mock_company(stubs={})
    @mock_company ||= mock(stubs)
  end
end
