require 'test_helper'

module Categories
  class WorkCategoriesControllerTest < ControllerTestCase

    # SETUP
    # ============================================================
    setup do
      @sirka   = users(:sirka)
      @randa   = users(:randa)

      @article = works_type_describers(:article)
    end

    # CAN
    # ============================================================
    # READ
    # ------------------------------------------------------------
    test "should get index" do
      sign_in @randa
      
      get :index

      assert_response :success
      assert_not_nil assigns(:work_categories)
    end

    test "should show category" do
      sign_in @randa

      get :show, id: @article.id

      assert_response :success
      assert_not_nil assigns(:work_category)
      assert_equal 3, assigns(:in_use_count)
    end

    # CANNOT
    # ============================================================
    # READ
    # ------------------------------------------------------------
    test "should not get index" do
      sign_in @sirka
      get :index
      assert_redirected_to root_path
    end

  end
end
