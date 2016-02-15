require 'test_helper'
module Works
  class ShortStoriesControllerTest < ControllerTestCase

    setup do
      @letty = users(:letty)
      @indra = users(:indra)
      @amiya = users(:amiya)
      @glamour = works(:glamour)
      @calypso = works(:calypso)
      @effaces = works(:effaces)
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
      sign_in @letty
      get :index
      assert assigns(:works).include? @glamour
      assert assigns(:works).include? @calypso
    end

    test "should show short story" do
      sign_in @letty
      get :show, id: @glamour.id
      assert_response :success
      assert_not_nil assigns(:work)
      assert_not_nil assigns(:short)
    end

    test "should get new" do
      sign_in @letty
      get :new
      assert_response :success
      assert_not_nil assigns(:short)
    end

    test "should get edit" do
      sign_in @amiya
      get :edit, id: @calypso.id
      assert_response :success
      assert_not_nil assigns(:short)
    end

    # POST
    # ============================================================
    test "should create short story" do
      sign_in @letty

      assert_difference('Work.count') do
        post :create, short_story: {
          title: @glamour.title,
          summary: @glamour.summary,
          story_content: "Save me from more writing."
        }
      end

      assert_redirected_to short_story_path(assigns(:short))
    end

    # PATCH/PUT
    # ============================================================
    test "should update short story" do
      sign_in @indra
      patch :update, id: @effaces.id, short_story: {
        title: @glamour.title,
        summary: @glamour.summary,
        story_content: "Save me from more writing."
      }
      assert_redirected_to short_story_path(@effaces)
    end

    # DELETE
    # ============================================================
    test "should destroy short story" do
      sign_in @indra
      assert_difference('Work.count', -1) do
        delete :destroy, id: @effaces
      end

      assert_redirected_to works_path
    end

  end
end