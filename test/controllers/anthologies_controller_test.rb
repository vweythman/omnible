require 'test_helper'

class AnthologiesControllerTest < ControllerTestCase

  setup do
    @becca     = users(:becca)
    @folktales = anthologies(:folktales)
  end

  # GET
  # ============================================================
  test "should get index" do
    sign_in @becca
    get :index
    assert_response :success
    assert_not_nil assigns(:anthologies)
  end

  test "should show anthology" do
    sign_in @becca
    get :show, id: @folktales.id
    assert_response :success
    assert_not_nil assigns(:anthology)
  end

  test "should get new" do
    sign_in @becca
    get :new
    assert_response :success
    assert_not_nil assigns(:anthology)
  end

  test "should get edit" do
    sign_in @becca
    get :edit, id: @folktales.id
    assert_response :success
    assert_not_nil assigns(:anthology)
  end

  # POST
  # ============================================================
  test "should create anthology" do
    sign_in @becca

    assert_difference('Anthology.count') do
      post :create, anthology: {
        name: @folktales.name,
        summary: @folktales.summary
      }
    end

    assert_redirected_to anthology_path(assigns(:anthology))
  end

  # PATCH/PUT
  # ============================================================
  test "should update anthology" do
    sign_in @becca
    patch :update, id: @folktales.id, anthology: {
      name: @folktales.name,
      summary: @folktales.summary
    }
    assert_redirected_to anthology_path(@folktales)
  end

  # DELETE
  # ============================================================
  test "should destroy anthology" do
    sign_in @becca
    assert_difference('Anthology.count', -1) do
      delete :destroy, id: @folktales
    end

    assert_redirected_to anthologies_path
  end
end
