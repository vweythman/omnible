require 'test_helper'

module Taggings
  class ActivitiesControllerTest < ControllerTestCase

    # SETUP
    # ============================================================
    setup do
      @randa = users(:randa)
      @seek  = activities(:seek)
    end

    # GET
    # ============================================================
    test "should get index" do
      sign_in @randa
      get :index
      assert_response :success
      assert_not_nil assigns(:activities)
    end

    test "should show activity" do
      sign_in @randa
      get :show, id: @seek
      assert_response :success
      assert_not_nil assigns(:activity)
    end

    test "should get edit" do
      sign_in @randa
      get :edit, id: @seek
      assert_response :success
      assert_not_nil assigns(:activity)
    end

    test "should not get edit" do
      get :edit, id: @seek
      assert_redirected_to root_path
    end

    # PATCH/PUT
    # ============================================================
    test "should update activity" do
      sign_in @randa
      patch :update, id: @seek, activity: { name: @seek.name }
      assert_redirected_to activity_path(assigns(:activity))
    end

    # DELETE
    # ============================================================
    test "should destroy activity" do
      sign_in @randa
      assert_difference('Activity.count', -1) do
        delete :destroy, id: @seek
      end

      assert_redirected_to activities_path
    end

  end
end