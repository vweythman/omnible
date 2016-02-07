require 'test_helper'

class ControlsControllerTest < ControllerTestCase
  setup do
    @letty = users(:letty)
    @randa = users(:randa)
    @controller = Admin::ControlsController.new
  end

  test "should get show" do
    sign_in @randa
    get :show
    assert_response :success
  end

  test "should redirect" do
    sign_in @letty
    get :show
    assert_redirected_to root_path
  end
end
