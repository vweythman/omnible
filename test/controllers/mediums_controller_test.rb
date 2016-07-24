require 'test_helper'

class MediumsControllerTest < ControllerTestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
