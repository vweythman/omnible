require 'test_helper'

module Subjects
  class SquadsControllerTest < ControllerTestCase
    # SETUP
    # ============================================================
    setup do
      @group = squads(:one)
      @amiya = users(:amiya)
    end

    # GET
    # ============================================================
    # INDEX
    # ------------------------------------------------------------
    test "should get index" do
      get :index
      assert_response :success
    end

    test "should get show" do
      sign_in @amiya
      get :show, id: @group
      assert_response :success
    end

    test "should get new" do
      sign_in @amiya
      get :new
      assert_response :success
    end

    test "should get edit" do
      sign_in @amiya
      get :edit, id: @group
      assert_response :success
    end

  end
end
