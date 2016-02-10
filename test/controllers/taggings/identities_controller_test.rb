require 'test_helper'

module Taggings
  class IdentitiesControllerTest < ControllerTestCase

    # SETUP
    # ============================================================
    setup do
      @randa = users(:randa)
      @young = identities(:young)
    end

    # GET
    # ============================================================
    test "should get index" do
      sign_in @randa
      get :index
      assert_response :success
      assert_not_nil assigns(:tags)
    end

    test "should show identity" do
      sign_in @randa
      get :show, id: @young
      assert_response :success
      assert_not_nil assigns(:identity)
    end

    test "should get edit" do
      sign_in @randa
      get :edit, id: @young
      assert_response :success
      assert_not_nil assigns(:identity)
    end

    test "should not get edit" do
      get :edit, id: @young
      assert_redirected_to root_path
    end

    # PATCH/PUT
    # ============================================================
    test "should update identity" do
      sign_in @randa
      patch :update, id: @young, identity: { name: @young.name }
      assert_redirected_to identity_path(assigns(:identity))
    end

    test "should update identity with new facet" do
      sign_in @randa
      patch :update, id: @young, identity: { name: @young.name, nature: 'aspect' }
      assert_redirected_to identity_path(assigns(:identity))
      assert_equal 'aspect', assigns(:identity).facet.name
    end

    # DELETE
    # ============================================================
    test "should destroy identity" do
      sign_in @randa
      assert_difference('Identity.count', -1) do
        delete :destroy, id: @young
      end

      assert_redirected_to identities_path
    end

  end
end
