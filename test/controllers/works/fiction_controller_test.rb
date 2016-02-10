require 'test_helper'

module Works
 class FictionControllerTest < ControllerTestCase

    setup do
      @indra    = users(:indra)
      @skywalks = works(:skywalks)
      @calypso  = works(:calypso)
    end

    # GET
    # ============================================================
    test "should get index" do
      sign_in @indra
      get :index
      assert_response :success
      assert_not_nil assigns(:works)

      assert assigns(:works).include? @calypso
      assert_not assigns(:works).include? @skywalks

    end

  end
end
