require 'test_helper'

module Taggings
  class RelatorsControllerTest < ControllerTestCase

    # SETUP
    # ============================================================
    setup do
      @randa = users(:randa)
      @familial = relators(:familial)
    end

    # GET
    # ============================================================
    test "should get index" do
      sign_in @randa
      get :index
      assert_response :success
      assert_not_nil assigns(:relators)
    end

    test "should show relator" do
      sign_in @randa
      get :show, id: @familial
      assert_response :success
      assert_not_nil assigns(:relator)
    end

    test "should get edit" do
      sign_in @randa
      get :edit, id: @familial
      assert_response :success
      assert_not_nil assigns(:relator)
    end

    test "should not get edit" do
      get :edit, id: @familial
      assert_redirected_to root_path
    end

    # POST
    # ============================================================
    test "should create relator without right name" do
      sign_in @randa

      assert_difference('Relator.count') do
        post :create, relator: { left_name: "cousin", right_name: "" }
      end

      assert_redirected_to relator_path(assigns(:relator))
      assert_not assigns(:relator).has_reverse?
    end

    test "should create relator with right name" do
      sign_in @randa

      assert_difference('Relator.count') do
        post :create, relator: { left_name: "husband", right_name: "wife" }
      end

      assert_redirected_to relator_path(assigns(:relator))
      assert assigns(:relator).has_reverse?
    end

    # PATCH/PUT
    # ============================================================
    test "should update relator" do
      sign_in @randa
      patch :update, id: @familial, relator: { left_name: @familial.left_name, right_name: @familial.right_name }
      assert_redirected_to relator_path(assigns(:relator))
    end

    # DELETE
    # ============================================================
    test "should destroy relator" do
      sign_in @randa
      assert_difference('Relator.count', -1) do
        delete :destroy, id: @familial
      end

      assert_redirected_to relators_path
    end

  end
end