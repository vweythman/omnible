require 'test_helper'

module Categories
  class CreatorCategoriesControllerTest < ControllerTestCase

    # SETUP
    # ============================================================
    setup do
      @sirka   = users(:sirka)
      @randa   = users(:randa)

      @writer  = creator_categories(:writer)
      @poem    = works_type_describers(:poem)
      @article = works_type_describers(:article)
    end



    # CAN
    # ============================================================
    # CREATE
    # ------------------------------------------------------------
    test "should get new" do
      sign_in @randa

      get :new

      assert_response :success
      assert_not_nil assigns(:creator_category)
    end

    test "should create category and redirect" do
      sign_in @randa

      assert_difference('CreatorCategory.count') do
        post :create, format: 'html', creator_category: 
        {
          name: 'composer',
          agentive: 'composed by'
        }
      end

      assert_redirected_to creator_category_path(assigns(:creator_category))
    end

    test "should create category and render js" do
      sign_in @randa

      assert_difference('CreatorCategory.count') do
        post :create, format: 'js', creator_category: 
        {
          name: 'composer',
          agentive: 'composed by'
        }
      end

      assert_response :success
      assert_not_nil assigns(:creator_category)
      assert_not_nil assigns(:creator_categories)
    end


    # READ
    # ------------------------------------------------------------
    test "should get index" do
      sign_in @randa
      
      get :index

      assert_response :success
      assert_not_nil assigns(:creator_categories)
    end

    test "should show category" do
      sign_in @randa

      get :show, id: @writer.id

      assert_response :success
      assert_not_nil assigns(:creator_category)
    end


    # UPDATE
    # ------------------------------------------------------------
    # GET
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    test "should get edit" do
      sign_in @randa

      get :edit, id: @writer.id

      assert_response :success
      assert_not_nil assigns(:creator_category)
    end

    # PATCH :: HTML
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    test "should update category and redirect" do
      sign_in @randa
      patch :update, id: @writer.id, creator_category: 
      {
        name: @writer.name,
        agentive: @writer.agentive,
        work_types: [@writer.type_describers.pluck(:id)]
      }
      assert_redirected_to creator_category_path(assigns(:creator_category))
    end

    # PATCH :: JS
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    test "should update category without describers" do
      sign_in @randa

      patch :update, id: @writer.id, format: 'js', creator_category: 
      { 
        name: @writer.name,
        agentive: @writer.agentive 
      }

      assert_response :success
      assert_not_nil assigns(:creator_category)
      assert_empty assigns(:creator_category).type_describers
    end

    test "should update category with new describer" do
      sign_in @randa
      assert_not @writer.connected? @poem

      patch :update, id: @writer.id, format: 'js', creator_category: 
      {
        name: @writer.name,
        agentive: @writer.agentive,
        work_types: [@poem.id]
      }

      assert_response :success
      assert_not_nil assigns(:creator_category)
      assert assigns(:creator_category).connected? @poem
    end

    test "should update category without old describer" do
      sign_in @randa
      assert @writer.connected? @article

      patch :update, id: @writer, format: 'js', creator_category: 
      {
        name: @writer.name,
        agentive: @writer.agentive,
        work_types: [@writer.type_describers.pluck(:id) - [@article]] 
      }

      assert_response :success
      assert_not_nil assigns(:creator_category)
      assert_not assigns(:creator_category).connected? @article
    end


    # DESTROY
    # ------------------------------------------------------------
    test "should destroy category" do
      sign_in @randa

      assert_difference('CreatorCategory.count', -1) do
        delete :destroy, id: @writer
      end

      assert_redirected_to creator_categories_path
    end



    # CANNOT
    # ============================================================
    # CREATE
    # ------------------------------------------------------------
    test "should not create" do
      sign_in @sirka

      assert_no_difference('CreatorCategory.count') do
        post :create, format: 'html', creator_category: 
        {
          name: 'composer',
          agentive: 'composed by'
        }
      end
    end


    # READ
    # ------------------------------------------------------------
    test "should not get index" do
      sign_in @sirka
      get :index
      assert_redirected_to root_path
    end

  end
end
