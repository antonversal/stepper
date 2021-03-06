require 'helper'

class ControllerResourceTest < ActiveSupport::TestCase
    setup do
      @params = HashWithIndifferentAccess.new(:controller => "companies")
      @controller_class = Class.new
      @controller = @controller_class.new
      @controller.stubs(:params).returns(@params)
    end

    test "should load resource into instance variable if params[:id] is specified" do
      Company.stubs(:find).with(1).returns(mock_company(:id => 1))
      @params.merge!(:action => "next_step", :id => mock_company.id)
      resource = Stepper::ControllerResource.new(@controller)
      resource.load_resource
      assert_equal @controller.instance_variable_get(:@company), mock_company
    end

    test "should build resource and load into instance variable if params[:id] is not specified" do
      Company.stubs(:new).returns(mock_company)
      @params.merge!(:action => "some_action")
      resource = Stepper::ControllerResource.new(@controller)
      resource.load_resource
      assert_equal @controller.instance_variable_get(:@company), mock_company
    end

    test "should load resource into instance variable(:new)" do
      Company.stubs(:new).returns(mock_company)
      @params.merge!(:action => "create")
      resource = Stepper::ControllerResource.new(@controller)
      resource.load_resource
      assert_equal @controller.instance_variable_get(:@company), mock_company
    end

    test "should not load resource into instance variable if instance variable exists" do
      @controller.instance_variable_set(:@company, mock_company)
      @params.merge!(:action => "next_step", :id => 15)
      resource = Stepper::ControllerResource.new(@controller)
      resource.load_resource
      assert_equal @controller.instance_variable_get(:@company), mock_company
    end

    protected
      def mock_company(stubs={})
        @mock_company ||= mock(stubs)
      end


end