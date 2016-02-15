require 'test_helper'

module Users
  class PenSwitchesControllerTest < ControllerTestCase

    setup do
      @amiya = users(:amiya)
      @letty = users(:letty)
      @pen   = pseudonymings(:creator_pen_four)
    end
    
    test "should switch status" do
      sign_in @amiya

      patch :update, pen_naming_id: @pen.id, format: 'js'

      assert assigns(:name).prime?
      assert_not assigns(:curr).prime?
    end

    test "should not switch status" do
      sign_in @letty

      patch :update, pen_naming_id: @pen.id, format: 'js'

      assert_not assigns(:name).prime?
      assert assigns(:curr).prime?
    end

  end
end
