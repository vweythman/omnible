require 'test_helper'

module Categories
  class FacetsControllerTest < ControllerTestCase

    # SETUP
    # ============================================================
    setup do
      @sirka = users(:sirka)
      @randa = users(:randa)
      @age   = facets(:age)
    end



    # CAN
    # ============================================================
    # CREATE
    # ------------------------------------------------------------
    test "should get new" do
      # :: setup
      sign_in @randa

      # :: process
      get :new

      # :: result
      assert_response :success
      assert_not_nil assigns(:facet)
    end

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

    test "should create facet and render js" do
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


    # READ
    # ------------------------------------------------------------
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


    # UPDATE
    # ------------------------------------------------------------
    test "should get edit" do
      # :: setup
      sign_in @randa

      # :: process
      get :edit, id: @age

      # :: result
      assert_response :success
      assert_not_nil assigns(:facet)
    end

    test "should update facet and redirect" do
      sign_in @randa
      patch :update, id: @age, facet: { name: @age.name }
      assert_redirected_to facet_path(assigns(:facet))
    end

    test "should update facet and render js" do
      # :: setup
      sign_in @randa

      # :: process
      patch :update, id: @age, facet: { name: @age.name }, format: 'js'

      # :: result
      assert_response :success
      assert_not_nil assigns(:facet)
    end


    # DESTROY
    # ------------------------------------------------------------
    test "should destroy facet" do
      sign_in @randa

      assert_difference('Facet.count', -1) do
        delete :destroy, id: @age, format: 'js'
      end

      assert_response :success
      assert_not_nil assigns(:facets)
    end

    test "should destroy facet and redirect" do
      sign_in @randa

      assert_difference('Facet.count', -1) do
        delete :destroy, id: @age
      end

      assert_redirected_to facets_path
    end


    # CANNOT
    # ============================================================
    # CREATE
    # ------------------------------------------------------------
    test "should not create" do
      sign_in @sirka
      assert_no_difference('Facet.count') do
        post :create, facet: { name: 'status' }, format: 'html'
      end
      assert_redirected_to facets_path
    end

    # DESTROY
    # ------------------------------------------------------------
    test "should not destroy facet" do
      sign_in @sirka

      assert_no_difference('Facet.count') do
        delete :destroy, id: @age
      end
    end

  end
end
