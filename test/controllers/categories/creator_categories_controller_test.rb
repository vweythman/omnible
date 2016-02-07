require 'test_helper'

module Categories
  class CreatorCategoriesControllerTest < ControllerTestCase

    setup do
      @sirka   = users(:sirka)
      @randa   = users(:randa)

      @writer  = creator_categories(:writer)
      @poem    = works_type_describers(:poem)
      @article = works_type_describers(:article)
    end

    test "should redirect when not admin" do
      sign_in @sirka
      get :index
      assert_redirected_to root_path
    end

    # GET
    # ============================================================
    test "should get index" do
      sign_in @randa
      
      get :index

      assert_response :success
      assert_not_nil assigns(:creator_categories)
    end

    test "should show category" do
      sign_in @randa

      get :show, id: @writer

      assert_response :success
      assert_not_nil assigns(:creator_category)
    end

    test "should get new" do
      sign_in @randa

      get :new

      assert_response :success
      assert_not_nil assigns(:creator_category)
    end

    test "should get edit" do
      sign_in @randa

      get :edit, id: @writer

      assert_response :success
      assert_not_nil assigns(:creator_category)
    end

    # POST
    # ============================================================
    test "should create category and redirect" do
      sign_in @randa
      assert_equal 3, CreatorCategory.count

      assert_difference('CreatorCategory.count') do
        post :create, creator_category: { name: 'composer', agentive: 'composed by' }, format: 'html'
      end

      assert_redirected_to creator_category_path(assigns(:creator_category))
    end

    test "should create category and grab list" do
      sign_in @randa

      assert_difference('CreatorCategory.count') do
        post :create, creator_category: { name: 'composer', agentive: 'composed by' }, format: 'js'
      end

      assert_response :success
      assert_not_nil assigns(:creator_category)
      assert_not_nil assigns(:creator_categories)
    end

    # PATCH/PUT
    # ============================================================
    test "should update category and redirect" do
      sign_in @randa
      patch :update, id: @writer, creator_category: { name: @writer.name, agentive: @writer.agentive, work_types: [@writer.type_describers.pluck(:id)] }
      assert_redirected_to creator_category_path(assigns(:creator_category))
    end

    test "should update category without describers and render js file" do
      sign_in @randa

      patch :update, id: @writer, creator_category: { name: @writer.name, agentive: @writer.agentive }, format: 'js'

      assert_response :success
      assert_not_nil assigns(:creator_category)
      assert_empty assigns(:creator_category).type_describers
    end

    test "should update category with new describer" do
      sign_in @randa
      assert_not @writer.connected? @poem

      patch :update, id: @writer, creator_category: { name: @writer.name, agentive: @writer.agentive, work_types: [@poem.id] }, format: 'js'

      assert_response :success
      assert_not_nil assigns(:creator_category)
      assert assigns(:creator_category).connected? @poem
    end

    test "should update category without old describer" do
      sign_in @randa
      assert @writer.connected? @article

      patch :update, id: @writer, creator_category: { name: @writer.name, agentive: @writer.agentive, work_types: [@writer.type_describers.pluck(:id) - [@article]] }, format: 'js'

      assert_response :success
      assert_not_nil assigns(:creator_category)
      assert_not assigns(:creator_category).connected? @article
    end

    # DELETE
    # ============================================================
    test "should destroy category" do
      sign_in @randa

      assert_difference('CreatorCategory.count', -1) do
        delete :destroy, id: @writer
      end

      assert_redirected_to creator_categories_path
    end

  end
end
