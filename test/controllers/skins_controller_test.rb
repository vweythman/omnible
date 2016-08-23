require 'test_helper'

class SkinsControllerTest < ControllerTestCase

  setup do
    @letty = users(:letty)
    @skin  = skins(:one)
  end

  # GET
  # ============================================================
  test "should get index" do
    sign_in @letty
    get :index
    assert_response :success
    assert_not_nil assigns(:skins)
  end

  test "should show skin" do
    sign_in @letty
    get :show, id: @skin
    assert_response :success
    assert_not_nil assigns(:skin)
  end

  test "should get new" do
    sign_in @letty
    get :new
    assert_response :success
    assert_not_nil assigns(:skin)
  end

  test "should get edit" do
    sign_in @letty
    get :edit, id: @skin
    assert_response :success
    assert_not_nil assigns(:skin)
  end

  # POST
  # ============================================================
  test "should create skin" do
    sign_in @letty

    assert_difference('Skin.count') do
      post :create, skin: { title: "new title", style: "p { font-size: 11em; }", uploader_id: @skin.uploader_id, status: 'Public' }
    end

    assert_redirected_to skin_path(assigns(:skin))
  end

  # PATCH/PUT
  # ============================================================
  test "should update skin" do
    sign_in @letty
    patch :update, id: @skin, skin: { title: @skin.title, style: @skin.style, uploader_id: @skin.uploader_id, status: 'Public' }
    assert_redirected_to skin_path(assigns(:skin))
  end

  # DELETE
  # ============================================================
  test "should destroy skin" do
    sign_in @letty
    assert_difference('Skin.count', -1) do
      delete :destroy, id: @skin
    end

    assert_redirected_to skins_path
  end

end
