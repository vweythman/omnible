require 'test_helper'

class UsersControllerTest < ControllerTestCase

    setup do
      @letty = users(:letty)
    end
    
    test "should get show" do
      get :show, id: @letty.id
      assert_response :success
    end

end
