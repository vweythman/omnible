require 'test_helper'
module Works
  class StoriesControllerTest < ControllerTestCase

    setup do
      @letty = users(:letty)
      @indra = users(:indra)
      @amiya = users(:amiya)
      @frenzy = works(:frenzy)
      @helix  = works(:helix)
      @heart  = works(:heart)
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
      assert assigns(:works).include? @helix
      assert_not assigns(:works).include? @frenzy
    end

    test "should show story" do
      sign_in @letty
      get :show, id: @helix.id
      assert_redirected_to story_chapter_path(assigns(:story).id, assigns(:story).chapters.first.id)
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
      sign_in @amiya
      get :edit, id: @frenzy.id
      assert_response :success
      assert_not_nil assigns(:story)
    end

    # POST
    # ============================================================
    test "should create story" do
      sign_in @letty

      assert_difference('Work.count') do
        post :create, story: {
          title: @frenzy.title,
          summary: @frenzy.summary
        }
      end

      assert_redirected_to story_path(assigns(:story))
    end

    test "should create story with chapters" do
      sign_in @letty

      assert_difference('Chapter.count', 2) do
        post :create, story: {
          title: @frenzy.title,
          summary: @frenzy.summary,
          chapters_attributes: [
            {
              title: "Chapter 1",
              content: "The queen returns."
            },
            {
              title: "Chapter 1",
              content: "The queen leaves."
            }
          ]
        }
      end

      assert_redirected_to story_path(assigns(:story))
    end

    # PATCH/PUT
    # ============================================================
    test "should update story" do
      sign_in @indra
      patch :update, id: @heart.id, story: {
        title: @frenzy.title,
        summary: @frenzy.summary
      }
      assert_redirected_to story_path(@heart)
    end

    # DELETE
    # ============================================================
    test "should destroy story" do
      sign_in @indra
      assert_difference('Work.count', -1) do
        delete :destroy, id: @heart
      end

      assert_redirected_to works_path
    end

  end
end