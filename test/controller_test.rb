require 'helper'
require 'mocha'

require "stepper/has_steps"


class CompaniesController < ActionController::Base
  has_steps
end

class CompaniesControllerTest < ActionController::TestCase
  tests CompaniesController

  setup do
    Company.expects(:new).with({ 'name' => 'Hina' }).returns(mock_company)
    mock_company.expects(:save).returns(true)
    mock_company.stubs(:id).returns(1)
  end

  def test_create_next_step
    post(:create, {:company => { :name => "Hina" }, :commit => "Next"})
    assert_response :redirect
    assert_redirected_to "http://test.host/companies/1/next_step"
  end

  def test_create_finish_later
    mock_company.stubs(:current_step).returns("step1")
    post(:create, {:company => { :name => "Hina" }, :commit => "Finish later"})
    assert_response :redirect
    assert_equal flash[:notice], "Step Step1 was successfully created."
    assert_redirected_to "http://test.host/companies"
  end

  protected
    def mock_company(stubs={})
      @mock_company ||= mock(stubs)
    end
end