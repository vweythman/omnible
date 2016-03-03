require 'test_helper'

module Works
  class BranchingStoriesControllerTest < ControllerTestCase

    setup do
      @letty = users(:letty)
      @indra = users(:indra)
      @amiya = users(:amiya)

      @gunrunner = works(:gunrunner)
      @hope      = works(:hope)
      @aqua      = works(:aqua)
      @zinc      = works(:zinc)
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
      assert assigns(:works).include? @hope
      assert assigns(:works).include? @aqua
      assert_not assigns(:works).include? @gunrunner
    end

    test "should show story" do
      sign_in @letty
      get :show, id: @aqua.id
      assert_response :success
      assert_not_nil assigns(:work)
      assert_not_nil assigns(:story)
    end

    test "should get new" do
      sign_in @letty
      get :new
      assert_response :success
      assert_not_nil assigns(:story)
    end

    test "should get edit" do
      sign_in @indra

      get :edit, id: @hope.id
      assert_response :success
      assert_not_nil assigns(:story)
    end

    # POST
    # ============================================================
    test "should create story" do
      sign_in @letty

      assert_difference('Work.count') do
        post :create, branching_story: {
          title:   @aqua.title,
          summary: @aqua.summary,
          story_root_attributes: {
            trunk_attributes: { title: "fight for the right", content: "test this content." }
          }
      }
      end

      assert_equal assigns(:story).id, assigns(:story).trunk.story_id 
      assert_redirected_to branching_story_path(assigns(:story))
    end

    # PATCH/PUT
    # ============================================================
    test "should update story" do
      sign_in @indra
      patch :update, id: @hope.id, branching_story: {
        title: @hope.title,
        summary: @hope.summary,
        story_content: "Save me from more writing."
      }
      assert_redirected_to branching_story_path(@hope)
    end

    # DELETE
    # ============================================================
    test "should destroy story" do
      sign_in @indra
      assert_difference('Work.count', -1) do
        delete :destroy, id: @hope
      end

      assert_redirected_to works_path
    end

  end
end
