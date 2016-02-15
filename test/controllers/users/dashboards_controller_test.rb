require 'test_helper'

class DashboardsControllerTest < ControllerTestCase

  setup do
    @controller = Users::DashboardsController.new
    @letty      = users(:letty)
  end
  
  test "should get show" do
    sign_in @letty
    get :show
    assert_response :success
  end

end
