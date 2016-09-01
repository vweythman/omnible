require 'test_helper'

class TrackingsControllerTest < ControllerTestCase

  # SETUP
  # ============================================================
  setup do
    # Users
    @randa   = users(:randa)
    @article = works(:apologia)
  end

  # CAN
  # ============================================================
  # CREATE
  # ------------------------------------------------------------
  test "should track a work" do
    sign_in @randa
    post :create, tracked_type: "Work", work_id: @article.id, format: 'js'
    assert_response :success
  end

  # DESTROY
  # ------------------------------------------------------------
  test "should stop tracking a work" do
    sign_in @randa
    delete :destroy, tracked_type: "Work", work_id: @article.id, format: 'js'
    assert_response :success
  end

end
