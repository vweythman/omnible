require 'test_helper'

module Works
  class WholeStoryControllerTest < ControllerTestCase

    setup do
      @letty = users(:letty)
      @indra = users(:indra)
      @amiya = users(:amiya)

      @frenzy = works(:frenzy)
      @helix  = works(:helix)
      @heart  = works(:heart)
    end

    # GET
    # ============================================================
    test "should show story" do
      sign_in @letty
      get :show, id: @helix.id
      assert_response :success
      assert_not_nil assigns(:work)
      assert_not_nil assigns(:story)
      assert_not_nil assigns(:chapters)
      assert assigns(:chapters).include? @helix.chapters.first
    end

  end
end