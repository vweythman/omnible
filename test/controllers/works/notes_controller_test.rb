require 'test_helper'
module Works
  class NotesControllerTest < ControllerTestCase
    # SETUP
    # ============================================================
    setup do
      # Users
      @indra = users(:indra) # blocked/blocking: tegan, sirka
      @letty = users(:letty)
      @sirka = users(:sirka)

      # Story
      # by indra
      # editable by not blocked users
      # viewable by not blocked users
      @heart = works(:heart) 

      # Notes
      @note1 = notes(:heart_note1)
    end


    # CAN
    # ============================================================
    # CREATE
    # ------------------------------------------------------------
    test "should get new" do
      sign_in @letty

      get :new, story_id: @heart.id

      assert_response :success
      assert_not_nil assigns(:work)
      assert_not_nil assigns(:note)
    end

    test "should create note" do
      sign_in @indra

      assert_difference('Note.count') do
        post :create, story_id: @heart.id, note: { title: @note1.title, content: @note1.content }
      end

      assert_not_nil assigns(:work)
      assert_not_nil assigns(:note)
      assert_equal assigns(:work), assigns(:note).work
      assert_redirected_to story_note_path(assigns(:work).id, assigns(:note).id)
    end

    # READ
    # ------------------------------------------------------------
    test "should get index" do
      sign_in @indra

      get :index, story_id: @heart.id

      assert_response :success
      assert_not_nil assigns(:work)
      assert_not_nil assigns(:notes)
    end

    test "should show note" do
      sign_in @indra

      get :show, story_id: @heart.id, id: @note1.id

      assert_response :success
      assert_not_nil assigns(:work)
      assert_not_nil assigns(:note)
    end

    # UPDATE
    # ------------------------------------------------------------
    test "should get edit" do
      sign_in @indra
      get :edit, id: @note1.id
      assert_response :success
      assert_not_nil assigns(:work)
      assert_not_nil assigns(:note)
    end

    test "should update note" do
      sign_in @indra
      patch :update, id: @note1.id, note: { title: @note1.title, content: @note1.content }
      assert_redirected_to story_note_path(assigns(:work).id, assigns(:note).id)
    end

    # DESTROY
    # ------------------------------------------------------------
    test "should destroy note" do
      sign_in @indra
      assert_difference('Note.count', -1) do
        delete :destroy, id: @note1.id
      end
    end



    # CANNOT
    # ============================================================
    # CREATE
    # ------------------------------------------------------------
    test "should not get new" do
      sign_in @sirka

      get :new, story_id: @heart.id

      assert_redirected_to story_path(assigns(:work))
    end

    test "should not create note" do
      sign_in @sirka

      assert_no_difference('Note.count') do
        post :create, story_id: @heart.id, note: { title: @note1.title }
      end

      assert_redirected_to story_path(assigns(:work))
    end


    # READ
    # ------------------------------------------------------------
    test "should not get index" do
      sign_in @sirka
      get :index, story_id: @heart.id

      assert_template 'works/restricted/show'
    end

    test "should not show note" do
      sign_in @sirka

      get :show, story_id: @heart.id, id: @note1.id

      assert_template 'works/restricted/show'
    end


    # UPDATE
    # ------------------------------------------------------------
    test "should not get edit" do
      sign_in @sirka
      get :edit, id: @note1.id
      assert_redirected_to story_path(assigns(:work))
    end

    test "should not update note" do
      sign_in @sirka
      patch :update, id: @note1.id, note: { title: @note1.title, content: @note1.content }
      assert_redirected_to story_path(assigns(:work))
    end


    # DESTROY
    # ------------------------------------------------------------
    test "should not destroy note" do
      sign_in @sirka
      assert_no_difference('Note.count') do
        delete :destroy, id: @note1.id
      end
    end

  end
end
