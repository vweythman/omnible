require 'test_helper'
module Works
  class ChaptersControllerTest < ControllerTestCase

    # SETUP
    # ============================================================
    setup do
      # Users
      @letty = users(:letty)
      @becca = users(:becca)
      @tegan = users(:tegan)

      @indra = users(:indra) # blocked/blocking: tegan, sirka
      @amiya = users(:amiya)
      @sirka = users(:sirka) # friends/followers: randa, letty

      # Stories
      @frenzy = works(:frenzy) # by amiya | editable by creator only | viewable by creator only
      @helix  = works(:helix)  # by sirka | editable by friends/followers | viewable by members 
      @heart  = works(:heart)  # by indra | editable by not blocked users | viewable by not blocked users

      # Chapters
      @frenzy0 = chapters(:frenzy_zero)
      @helix1  = chapters(:helix_one)
      @helix2  = chapters(:helix_two)
      @heart0  = chapters(:heart_zero)
    end


    # CAN
    # ============================================================
    # CREATE
    # ------------------------------------------------------------
    test "should get new" do
      sign_in @letty

      get :new, story_id: @helix.id

      assert_response :success
      assert_not_nil assigns(:story)
      assert_not_nil assigns(:chapter)
    end

    test "should create chapter" do
      sign_in @amiya

      assert_difference('Chapter.count') do
        post :create, story_id: @frenzy.id, chapter: { title: @helix1.title, content: @helix1.content }
      end

      assert_not_nil assigns(:story)
      assert_not_nil assigns(:chapter)
      assert_not_nil assigns(:chapter).topic
      assert_equal assigns(:story), assigns(:chapter).story
      assert_redirected_to story_chapter_path(assigns(:story).id, assigns(:chapter).id)
    end


    # READ
    # ------------------------------------------------------------
    test "should get index" do
      sign_in @sirka

      get :index, story_id: @helix.id

      assert_response :success
      assert_not_nil assigns(:story)
      assert_not_nil assigns(:chapters)
    end

    test "should show chapter" do
      sign_in @indra

      get :show, story_id: @heart.id, id: @heart0.id

      assert_response :success
      assert_not_nil assigns(:story)
      assert_not_nil assigns(:chapter)
    end


    # UPDATE
    # ------------------------------------------------------------
    test "should get edit" do
      sign_in @letty
      get :edit, id: @helix1.id
      assert_response :success
      assert_not_nil assigns(:work)
      assert_not_nil assigns(:chapter)
    end

    test "should update chapter" do
      sign_in @letty
      patch :update, id: @helix1.id, chapter: { title: @helix1.title, content: @helix1.content }
      assert_redirected_to story_chapter_path(assigns(:story).id, assigns(:chapter).id)
    end

    # DESTROY
    # ------------------------------------------------------------
    test "should destroy chapter" do
      sign_in @letty
      assert_difference('Chapter.count', -1) do
        delete :destroy, id: @helix1.id
      end
    end


    # CANNOT
    # ============================================================
    # CREATE
    # ------------------------------------------------------------
    test "should not get new" do
      sign_in @amiya

      get :new, story_id: @helix.id

      assert_redirected_to story_path(assigns(:story))
    end

    test "should not create chapter" do
      sign_in @letty

      assert_no_difference('Chapter.count') do
        post :create, story_id: @frenzy.id, chapter: { title: @frenzy.title }
      end

      assert_redirected_to story_path(assigns(:story))
    end


    # READ
    # ------------------------------------------------------------
    test "should not get index" do
      get :index, story_id: @helix.id

      assert_template 'works/restricted/show'
    end

    test "should not show chapter" do
      sign_in @sirka

      get :show, story_id: @heart.id, id: @heart0.id

      assert_template 'works/restricted/show'
    end


    # UPDATE
    # ------------------------------------------------------------
    test "should not get edit" do
      sign_in @sirka
      get :edit, id: @heart0.id
      assert_redirected_to story_path(assigns(:work))
    end

    test "should not update chapter" do
      sign_in @indra
      patch :update, id: @helix1.id, chapter: { title: @helix1.title, content: @helix1.content }
      assert_redirected_to story_path(assigns(:story))
    end


    # DESTROY
    # ------------------------------------------------------------
    test "should not destroy chapter" do
      sign_in @amiya
      assert_no_difference('Chapter.count') do
        delete :destroy, id: @helix1.id
      end
    end

  end
end
