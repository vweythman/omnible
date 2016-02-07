require 'test_helper'

class PenNamingsControllerTest < ControllerTestCase
  setup do
    @letty = users(:letty)
    @controller = Users::PenNamingsController.new
  end

  test "should get index" do
    sign_in @letty
    get :index
    assert_response :success
  end

end
