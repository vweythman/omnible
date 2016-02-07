require 'test_helper'

class ControlsControllerTest < ControllerTestCase

  setup do
    @sirka = users(:sirka)
    @randa = users(:randa)
    @controller = Admin::ControlsController.new
  end

  test "should redirect" do
    sign_in @sirka
    get :show
    assert_redirected_to root_path
  end

  test "should get show" do
    sign_in @randa
    get :show
    assert_response :success
    assert_not_nil assigns(:user)
  end

end
