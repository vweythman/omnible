require 'test_helper'

module Subjects
  class PlacesControllerTest < ControllerTestCase

    # SETUP
    # ============================================================
    setup do
      @actual_earth = places(:actual_earth)
      @nile         = places(:nile)
      @planet       = forms(:planet)

      @amiya = users(:amiya)
      @tegan = users(:tegan)
    end

    # GET
    # ============================================================
    # INDEX
    # ------------------------------------------------------------
    test "should get index" do
      get :index

      assert_response :success
      assert_not_nil assigns(:places)
      assert_not_nil assigns(:subjects)
      assert_equal assigns(:places), assigns(:subjects)
    end

    # SHOW
    # ------------------------------------------------------------
    test "should show place" do
      get :show, id: @actual_earth.id

      assert_response :success
      assert_not_nil assigns(:place)
    end

    # NEW
    # ------------------------------------------------------------
    test "should get new" do
      sign_in @amiya

      get :new

      assert_response :success
      assert_not_nil assigns(:place)
    end

    test "should not get new" do
      get :new

      assert_redirected_to root_path
    end

    # EDIT
    # ------------------------------------------------------------
    test "should not get edit" do
      sign_in @tegan

      get :edit, id: @actual_earth

      assert_redirected_to @actual_earth
    end

    test "should get edit" do
      sign_in @amiya

      get :edit, id: @actual_earth

      assert_response :success
      assert_not_nil assigns(:place)
    end

    # POST
    # ============================================================
    test "should create place" do
      sign_in @tegan

      assert_difference('Place.count') do
        post :create, place: { name: "Mars", nature: "planet", editor_level: Editable::PERSONAL, publicity_level: Editable::PERSONAL }
      end

      assert_equal "planet", assigns(:place).form.name
      assert_redirected_to place_path(assigns(:place))
    end

    # PATCH/PUT
    # ============================================================
    test "should update place" do
      sign_in @amiya

      patch :update, id: @actual_earth, place: { name: @actual_earth.name, nature: "planet", editor_level: @actual_earth.editor_level, publicity_level: @actual_earth.editor_level }

      assert_redirected_to place_path(assigns(:place))
    end

    # DELETE
    # ============================================================
    test "should destroy place" do
      sign_in @amiya

      assert_difference('Place.count', -1) do
        delete :destroy, id: @actual_earth
      end

      assert_redirected_to places_path
    end

  end
end
