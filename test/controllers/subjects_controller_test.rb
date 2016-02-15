require 'test_helper'

class SubjectsControllerTest < ControllerTestCase

  test "should get index" do
    get :index
    assert_response :success
  end

end
