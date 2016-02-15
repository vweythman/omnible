require 'test_helper'

module Users
  class SkinsControllerTest < ControllerTestCase

    setup do
      @letty = users(:letty)
    end
    
    test "should get index" do
      sign_in @letty
      get :index
      assert_response :success
    end

  end
end
