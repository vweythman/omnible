require 'test_helper'

class SkinsControllerTest < ActionController::TestCase
  setup do
    @user_skin = user_skins(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_skins)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_skin" do
    assert_difference('UserSkin.count') do
      post :create, user_skin: { style: @user_skin.style, uploader_id: @user_skin.uploader_id }
    end

    assert_redirected_to user_skin_path(assigns(:user_skin))
  end

  test "should show user_skin" do
    get :show, id: @user_skin
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_skin
    assert_response :success
  end

  test "should update user_skin" do
    patch :update, id: @user_skin, user_skin: { style: @user_skin.style, uploader_id: @user_skin.uploader_id }
    assert_redirected_to user_skin_path(assigns(:user_skin))
  end

  test "should destroy user_skin" do
    assert_difference('UserSkin.count', -1) do
      delete :destroy, id: @user_skin
    end

    assert_redirected_to user_skins_path
  end
end
