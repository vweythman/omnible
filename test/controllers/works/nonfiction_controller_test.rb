require 'test_helper'

module Works
  class NonfictionControllerTest < ControllerTestCase

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

      assert assigns(:works).include? @skywalks
      assert_not assigns(:works).include? @calypso
    end

  end
end
