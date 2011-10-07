require 'helper'

class RedirectControllerTest < ActionController::TestCase
  tests OrdersController

  setup do
    Order.expects(:find).with('1').returns(mock_order)
    mock_order.expects(:attributes=).with({'code' => '23'}).returns(true)
    mock_order.expects(:save).returns(true)
    mock_order.stubs(:id).returns(1)
  end

  test "should redirect to :action => :index if commit 'Save'" do
    mock_order.stubs(:stepper_current_step).returns("step2")
    mock_order.stubs(:previous_step!)
    put(:update, {:order => {:code => "23"}, :commit => "Finish later", :id => 1})
    assert_response :redirect
    assert_redirected_to "http://test.host/orders"
  end

  test "should redirect to show if commit 'Finish' and option is Proc" do
    mock_order.stubs(:stepper_current_step).returns("step3")
    put(:update, {:order => {:code => "23"}, :commit => "Finish form", :id => 1})
    assert_response :redirect
    assert_redirected_to "http://test.host/orders/1"
  end

  protected
    def mock_order(stubs={})
      @mock_order ||= mock(stubs)
    end
end

