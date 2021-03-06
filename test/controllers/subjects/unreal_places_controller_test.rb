require 'test_helper'

module Subjects
  class UnrealPlacesControllerTest < ControllerTestCase

    # SETUP
    # ============================================================
    setup do
      @actual_earth = places(:actual_earth)
      @middle_earth = places(:middle_earth)
    end

    # GET
    # ============================================================
    # INDEX
    # ------------------------------------------------------------
    test "should get index" do
      get :index

      assert_response :success
      assert assigns(:places).include? @middle_earth
      assert_not assigns(:places).include? @actual_earth
    end

  end
end
