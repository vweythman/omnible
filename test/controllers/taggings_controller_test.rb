require 'test_helper'

class TaggingsControllerTest < ControllerTestCase

    # SETUP
    # ============================================================
    setup do
      @sirka = users(:sirka)
      @randa = users(:randa)
      @young = identities(:young)
      @seek  = activities(:seek)
      @familial = relators(:familial)
    end

    # GET
    # ============================================================
    # INDEX
    # ------------------------------------------------------------
    test "should show all tags" do
      get :show

      assert_response :success
      assert assigns(:identities).include? @young
      assert assigns(:activities).include? @seek
      assert assigns(:relators).include? @familial
      assert_not_nil assigns(:qualities)
      assert_not_nil assigns(:tags)
    end

end
