require 'test_helper'

module Works
  class RestrictedControllerTest < ControllerTestCase

    setup do
      @letty = users(:letty)
      @becca = users(:becca)
      @tegan = users(:tegan)

      @frenzy = works(:frenzy) # by amiya | editable by creator only | viewable by creator only
      @helix  = works(:helix)  # by sirka | editable by friends/followers | viewable by members 
      @heart  = works(:heart)  # by indra | editable by not blocked users | viewable by not blocked users
    end

    # GET
    # ============================================================
    test "should show story" do
      sign_in @letty
      get :show, id: @heart.id
      assert_redirected_to story_path(assigns(:work))
    end

    test "should show restriction notice" do
      sign_in @tegan
      get :show, id: @heart.id
      assert_response :success
      assert_not_nil assigns(:work)
    end

  end
end