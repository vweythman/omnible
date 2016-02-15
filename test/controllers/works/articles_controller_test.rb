require 'test_helper'
module Works
  class ArticlesControllerTest < ControllerTestCase

    setup do
      @letty    = users(:letty)
      @indra    = users(:indra)
      @amiya    = users(:amiya)
      @theocrat = works(:theocrat)
      @apologia = works(:apologia)
      @skywalks = works(:skywalks)
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
      assert assigns(:works).include? @theocrat
      assert_not assigns(:works).include? @apologia
    end

    test "should show article" do
      sign_in @letty
      get :show, id: @theocrat.id
      assert_response :success
      assert_not_nil assigns(:work)
      assert_not_nil assigns(:article)
    end

    test "should get new" do
      sign_in @letty
      get :new
      assert_response :success
      assert_not_nil assigns(:article)
    end

    test "should get edit" do
      sign_in @amiya
      get :edit, id: @theocrat.id
      assert_response :success
      assert_not_nil assigns(:article)
    end

    # POST
    # ============================================================
    test "should create article" do
      sign_in @letty

      assert_difference('Work.count') do
        post :create, article: {
          title: @theocrat.title,
          summary: @theocrat.summary,
          article_content: "Save me from more writing."
        }
      end

      assert_redirected_to article_path(assigns(:article))
    end

    # PATCH/PUT
    # ============================================================
    test "should update article" do
      sign_in @indra
      patch :update, id: @skywalks.id, article: {
        title: @theocrat.title,
        summary: @theocrat.summary,
        article_content: "Save me from more writing."
      }
      assert_redirected_to article_path(@skywalks)
    end

    # DELETE
    # ============================================================
    test "should destroy article" do
      sign_in @indra
      assert_difference('Work.count', -1) do
        delete :destroy, id: @skywalks
      end

      assert_redirected_to works_path
    end

  end
end