require 'test_helper'
module Works
  class RecordsControllerTest < ControllerTestCase

    # SETUP
    # ============================================================
    setup do
      @randa = users(:randa)
      @indra = users(:indra)
      @do    = works(:do)
    end

    # CAN
    # ============================================================
    # CREATE
    # ------------------------------------------------------------
    test "should get new" do
      sign_in @randa
      get :new
      assert_response :success
      assert_not_nil assigns(:record)
    end

    test "should create record" do
      sign_in @randa

      assert_difference('Work.count') do
        post :create, record: {
          title: @do.title,
          summary: @do.summary
        }
      end

      assert_redirected_to record_path(assigns(:record))
    end

    # READ
    # ------------------------------------------------------------
    test "should get index" do
      sign_in @randa
      get :index
      assert_response :success
      assert_not_nil assigns(:works)
    end

    test "should show record" do
      sign_in @randa
      get :show, id: @do.id
      assert_not_nil assigns(:work)
      assert_not_nil assigns(:record)
    end

    # UPDATE
    # ------------------------------------------------------------
    test "should get edit" do
      sign_in @randa
      get :edit, id: @do.id
      assert_response :success
      assert_not_nil assigns(:record)
    end

    test "should update record" do
      sign_in @randa
      patch :update, id: @do.id, record: {
        title: "??",
        summary: @do.summary
      }
      assert_equal "??", assigns(:record).title
      assert_redirected_to record_path(assigns(:record))
    end

    # DESTROY
    # ------------------------------------------------------------
    test "should destroy record" do
      sign_in @randa
      assert_difference('Work.count', -1) do
        delete :destroy, id: @do
      end

      assert_redirected_to works_path
    end

    # CANNOT
    # ============================================================
    # CREATE
    # ------------------------------------------------------------
    test "should not get new" do
      sign_in @indra
      get :new
      assert_redirected_to root_url
    end

    test "should not create record" do
      sign_in @indra

      assert_no_difference('Work.count') do
        post :create, record: {
          title: @do.title,
          summary: @do.summary
        }
      end
    end

    # READ
    # ------------------------------------------------------------
    # -- records are always readable

    # UPDATE
    # ------------------------------------------------------------
    test "should not get edit" do
      sign_in @indra
      get :edit, id: @do.id
      assert_redirected_to record_path(assigns(:record))
    end

    test "should not update record" do
      sign_in @indra
      patch :update, id: @do.id, record: {
        title: "??",
        summary: @do.summary
      }
      assert_not_equal "??", assigns(:record).title
    end

    # DESTROY
    # ------------------------------------------------------------
    test "should not destroy record" do
      sign_in @indra
      assert_no_difference('Work.count', -1) do
        delete :destroy, id: @do
      end
    end

  end
end