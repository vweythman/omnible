require 'test_helper'

class WorksControllerTest < ControllerTestCase

  # SETUP
  # ============================================================
  setup do
    # Users
    @letty = users(:letty)
    @becca = users(:becca)
    @tegan = users(:tegan)

    @indra = users(:indra)
    @amiya = users(:amiya)
    @sirka = users(:sirka)

    # Works
    @story = works(:heart)
    @link  = works(:zoologist)
  end

  # CAN
  # ============================================================
  # CREATE
  # ------------------------------------------------------------
  test "should get new" do
    sign_in @letty
    get :new
    assert_response :success
    assert_not_nil assigns(:work)
  end

  test "should create work" do
    sign_in @letty
    assert_difference('Work.count') do
      post :create, work: { title: @link.title }
    end

    assert_redirected_to work_path(assigns(:work))
  end


  # READ
  # ------------------------------------------------------------
  test "should get index" do
    sign_in @letty
    get :index
    assert_response :success
    assert_not_nil assigns(:works)
  end

  test "should show work" do
    sign_in @letty
    get :show, id: @link.id
    assert_response :success
    assert_not_nil assigns(:work)
  end


  # UPDATE
  # ------------------------------------------------------------
  test "should get edit" do
    sign_in @letty
    get :edit, id: @link.id
    assert_response :success
    assert_not_nil assigns(:work)
  end

  test "should update work" do
    sign_in @letty
    patch :update, id: @link.id, work: { title: @link.title }
    assert_redirected_to work_link_path(@link)
  end


  # DESTROY
  # ------------------------------------------------------------
  test "should destroy work" do
    sign_in @indra
    assert_difference('Work.count', -1) do
      delete :destroy, id: @link.id
    end

    assert_redirected_to works_path
  end



  # CANNOT
  # ============================================================
  # CREATE
  # ------------------------------------------------------------
  test "should not get new" do
    get :new
    assert_redirected_to root_path
  end


  # READ
  # ------------------------------------------------------------
  test "should not show work" do
    sign_in @sirka
    get :show, id: @story.id
    assert_response :success
    assert_template 'works/restricted/show'
  end


  # UPDATE
  # ------------------------------------------------------------
  test "should not get edit" do
    sign_in @sirka
    get :edit, id: @story.id
    assert_redirected_to story_path(assigns(:work))
  end

  test "should not update work" do
    sign_in @sirka

    patch :update, id: @story.id, work: { title: @link.title }

    assert_redirected_to story_path(assigns(:work))
    assert_not_equal @link.title, assigns(:work).title
  end


  # DESTROY
  # ------------------------------------------------------------
  test "should not destroy work" do
    sign_in @letty
    assert_no_difference('Work.count', -1) do
      delete :destroy, id: @link.id
    end

    assert_redirected_to work_link_path(assigns(:work))
  end

end
