require 'test_helper'

module Works
  class JournalsControllerTest < ControllerTestCase

    setup do
      @letty = users(:letty)
      @indra = users(:indra)
      @amiya = users(:amiya)
      @absurdist = works(:absurdist)
      @gunrunner = works(:gunrunner)
      @rainfalls = works(:rainfalls)
    end

    # GET
    # ============================================================
    test "should get index" do
      sign_in @letty
      get :index
      assert_response :success
      assert_not_nil assigns(:works)
    end

    test "should only get viewable works" do
      sign_in @amiya
      get :index
      assert assigns(:works).include? @rainfalls
      assert assigns(:works).include? @absurdist
      assert_not assigns(:works).include? @gunrunner
    end

    test "should show journal" do
      sign_in @letty
      get :show, id: @absurdist.id
      assert_response :success
      assert_not_nil assigns(:work)
      assert_not_nil assigns(:journal)
    end

    test "should get new" do
      sign_in @letty
      get :new
      assert_response :success
      assert_not_nil assigns(:journal)
    end

    test "should get edit" do
      sign_in @amiya
      get :edit, id: @absurdist.id
      assert_response :success
      assert_not_nil assigns(:journal)
    end

    # POST
    # ============================================================
    test "should create journal" do
      sign_in @letty

      assert_difference('Work.count') do
        post :create, journal: {
          title: @absurdist.title,
          summary: @absurdist.summary
        }
      end

      assert_redirected_to journal_path(assigns(:journal))
    end

    # PATCH/PUT
    # ============================================================
    test "should update journal" do
      sign_in @indra
      patch :update, id: @rainfalls.id, journal: {
        title: @absurdist.title,
        summary: @absurdist.summary,
        journal_content: "Save me from more writing."
      }
      assert_redirected_to journal_path(@rainfalls)
    end

    # DELETE
    # ============================================================
    test "should destroy journal" do
      sign_in @indra
      assert_difference('Work.count', -1) do
        delete :destroy, id: @rainfalls
      end

      assert_redirected_to works_path
    end

  end
end