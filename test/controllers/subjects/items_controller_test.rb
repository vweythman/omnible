require 'test_helper'

module Subjects
  class ItemsControllerTest < ControllerTestCase

    # SETUP
    # ============================================================
    setup do
      @aegis = items(:aegis)
      @excalibur = items(:excalibur)
      @sword     = generics(:sword)

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
      assert_not_nil assigns(:items)
      assert_not_nil assigns(:subjects)
      assert_equal assigns(:items), assigns(:subjects)
    end

    # SHOW
    # ------------------------------------------------------------
    test "should show item" do
      get :show, id: @aegis.id

      assert_response :success
      assert_not_nil assigns(:item)
    end

    # NEW
    # ------------------------------------------------------------
    test "should get new" do
      sign_in @amiya

      get :new

      assert_response :success
      assert_not_nil assigns(:item)
    end

    test "should not get new" do
      get :new

      assert_redirected_to root_path
    end

    # EDIT
    # ------------------------------------------------------------
    test "should not get edit" do
      sign_in @tegan

      get :edit, id: @aegis

      assert_redirected_to @aegis
    end

    test "should get edit" do
      sign_in @amiya

      get :edit, id: @aegis

      assert_response :success
      assert_not_nil assigns(:item)
    end

    # POST
    # ============================================================
    test "should create item" do
      sign_in @tegan

      assert_difference('Item.count') do
        post :create, item: { name: "Durandal", nature: "sword", descriptions: "magical", editor_level: Editable::PERSONAL, publicity_level: Editable::PERSONAL }
      end

      assert_redirected_to item_path(assigns(:item))
      assert_not_empty assigns(:item).qualities
      assert_equal @sword.id, assigns(:item).generic_id
    end

    # PATCH/PUT
    # ============================================================
    test "should update item" do
      sign_in @amiya

      patch :update, id: @aegis, item: { name: @aegis.name, nature: "shield", descriptions: "magical;ancient", editor_level: @aegis.editor_level, publicity_level: @aegis.editor_level }

      assert_redirected_to item_path(assigns(:item))
      assert_equal 2, assigns(:item).qualities.size
    end

    # DELETE
    # ============================================================
    test "should destroy item" do
      sign_in @amiya

      assert_difference('Item.count', -1) do
        delete :destroy, id: @aegis
      end

      assert_redirected_to items_path
    end

  end
end
