require "helper"
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