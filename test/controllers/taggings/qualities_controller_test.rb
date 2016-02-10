require 'test_helper'

module Taggings
  class QualitiesControllerTest < ControllerTestCase

    # SETUP
    # ============================================================
    setup do
      @randa = users(:randa)
      @red   = qualities(:red)
      @color = adjectives(:color)
    end

    # GET
    # ============================================================
    test "should get index" do
      sign_in @randa
      get :index
      assert_response :success
      assert_not_nil assigns(:tags)
    end

    test "should show quality" do
      sign_in @randa
      get :show, id: @red
      assert_response :success
      assert_not_nil assigns(:quality)
    end

    test "should get edit" do
      sign_in @randa
      get :edit, id: @red
      assert_response :success
      assert_not_nil assigns(:quality)
    end

    test "should not get edit" do
      get :edit, id: @red
      assert_redirected_to root_path
    end

    # PATCH/PUT
    # ============================================================
    test "should update quality" do
      sign_in @randa
      patch :update, id: @red, quality: { name: @red.name, adjective_id: @color.id }
      assert_redirected_to quality_path(assigns(:quality))
      assert_equal @color, assigns(:quality).adjective
    end

    # DELETE
    # ============================================================
    test "should destroy quality" do
      sign_in @randa
      assert_difference('Quality.count', -1) do
        delete :destroy, id: @red
      end

      assert_redirected_to qualities_path
    end

  end
end
