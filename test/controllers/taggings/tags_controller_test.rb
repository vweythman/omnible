require 'test_helper'

module Taggings
  class TagsControllerTest < ControllerTestCase

    # SETUP
    # ============================================================
    setup do
      @randa = users(:randa)
      @one   = tags(:one)
    end

    # GET
    # ============================================================
    test "should get index" do
      sign_in @randa
      get :index
      assert_response :success
      assert_not_nil assigns(:tags)
    end

    test "should show tag" do
      sign_in @randa
      get :show, id: @one
      assert_response :success
      assert_not_nil assigns(:tag)
    end

    test "should get edit" do
      sign_in @randa
      get :edit, id: @one
      assert_response :success
      assert_not_nil assigns(:tag)
    end

    test "should not get edit" do
      get :edit, id: @one
      assert_redirected_to root_path
    end

    # PATCH/PUT
    # ============================================================
    test "should update tag" do
      sign_in @randa
      patch :update, id: @one, tag: { name: @one.name }
      assert_redirected_to tag_path(assigns(:tag))
    end

    # DELETE
    # ============================================================
    test "should destroy tag" do
      sign_in @randa
      assert_difference('Tag.count', -1) do
        delete :destroy, id: @one
      end

      assert_redirected_to tags_path
    end

  end
end
