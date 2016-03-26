require 'test_helper'

module Works
  class StoryLinksControllerTest < ControllerTestCase

    setup do
      @letty = users(:letty)
      @becca = users(:becca)
      @indra = users(:indra)
      @tegan = users(:tegan)
      @amiya = users(:amiya)

      @viperfish = works(:viperfish)
      @windstorm = works(:windstorm)
      @zoologist = works(:zoologist)
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
      sign_in @indra
      get :index
      assert assigns(:works).include? @viperfish
      assert_not assigns(:works).include? @windstorm
    end

    test "should show link" do
      sign_in @letty
      get :show, id: @viperfish.id
      assert @viperfish.viewable? @letty
      assert_response :success
      assert_not_nil assigns(:work)
      assert_not_nil assigns(:link)
    end

    test "should get new" do
      sign_in @letty
      get :new
      assert_response :success
      assert_not_nil assigns(:link)
    end

    test "should get edit" do
      sign_in @amiya
      get :edit, id: @viperfish.id
      assert_response :success
      assert_not_nil assigns(:link)
    end

    # POST
    # ============================================================
    test "should create link" do
      sign_in @letty

      assert_difference('Work.count') do
        post :create, story_link: {
          title: @viperfish.title,
          sources_attributes: [
            {reference: "http://www.example.com"}
          ]
        }
      end

      assert_redirected_to story_link_path(assigns(:link))
    end

    # PATCH/PUT
    # ============================================================
    test "should update link" do
      sign_in @indra
      patch :update, id: @zoologist.id, story_link: {
        title: @viperfish.title
      }
      assert_redirected_to story_link_path(@zoologist)
    end

    # DELETE
    # ============================================================
    test "should destroy link" do
      sign_in @indra
      assert_difference('Work.count', -1) do
        delete :destroy, id: @zoologist
      end

      assert_redirected_to works_path
    end

  end

end