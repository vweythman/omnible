require 'test_helper'

module Categories
  class FacetsControllerTest < ControllerTestCase

    setup do
      @sirka = users(:sirka)
      @randa = users(:randa)
      @age   = facets(:age)
    end

    # GET
    # ============================================================
    test "should get index" do
      # :: setup
      sign_in @randa
      
      # :: process
      get :index

      # :: result
      assert_response :success
      assert_not_nil assigns(:facets)
    end

    test "should show facet" do
      # :: setup
      sign_in @randa

      # :: process
      get :show, id: @age

      # :: result
      assert_response :success
      assert_not_nil assigns(:facet)
    end

    test "should get new" do
      # :: setup
      sign_in @randa

      # :: process
      get :new

      # :: result
      assert_response :success
      assert_not_nil assigns(:facet)
    end

    test "should get edit" do
      # :: setup
      sign_in @randa

      # :: process
      get :edit, id: @age

      # :: result
      assert_response :success
      assert_not_nil assigns(:facet)
    end

    # POST
    # ============================================================
    test "should create facet and redirect" do
      # :: setup
      sign_in @randa
      assert_equal 3, Facet.count

      # :: process
      assert_difference('Facet.count') do
        post :create, facet: { name: 'status' }, format: 'html'
      end

      # :: result
      assert_redirected_to facet_path(assigns(:facet))
    end

    test "should create facet and grab list" do
      # :: setup
      sign_in @randa

      # :: process
      assert_difference('Facet.count') do
        post :create, facet: { name: 'status' }, format: 'js'
      end

      # :: result
      assert_response :success
      assert_not_nil assigns(:facet)
      assert_not_nil assigns(:facets)
    end

    test "should redirect when not admin" do
      sign_in @sirka
      post :create, facet: { name: 'status' }, format: 'html'
      assert_redirected_to facets_path
    end

    # PATCH/PUT
    # ============================================================
    test "should update facet and redirect" do
      sign_in @randa
      patch :update, id: @age, facet: { name: @age.name }
      assert_redirected_to facet_path(assigns(:facet))
    end

    test "should update facet and render js file" do
      # :: setup
      sign_in @randa

      # :: process
      patch :update, id: @age, facet: { name: @age.name }, format: 'js'

      # :: result
      assert_response :success
      assert_not_nil assigns(:facet)
    end

    # DELETE
    # ============================================================
    test "should destroy facet and redirect" do
      sign_in @randa

      assert_difference('Facet.count', -1) do
        delete :destroy, id: @age
      end

      assert_redirected_to facets_path
    end

    test "should destroy facet" do
      sign_in @randa

      assert_difference('Facet.count', -1) do
        delete :destroy, id: @age, format: 'js'
      end

      assert_response :success
      assert_not_nil assigns(:facets)
    end

  end
end
