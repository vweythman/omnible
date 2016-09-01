require 'test_helper'

class DislikesControllerTest < ControllerTestCase

  # SETUP
  # ============================================================
  setup do
    # Users
    @randa   = users(:randa)
    @article = works(:apologia)
  end

  # CAN
  # ============================================================
  test "should create" do
    sign_in @randa
    post :create, work_id: @article.id, format: 'js'
    assert_response :success
  end

  test "should get destroy" do
    sign_in @randa
    delete :destroy, work_id: @article.id, format: 'js'
    assert_response :success
  end

end
