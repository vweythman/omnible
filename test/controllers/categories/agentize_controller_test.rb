require 'test_helper'

module Categories
  class AgentizeControllerTest < ControllerTestCase

    # SETUP
    # ============================================================
    setup do
      @sirka   = users(:sirka)
      @randa   = users(:randa)

      @poem    = works_type_describers(:poem)
      @article = works_type_describers(:article)
      
      @writer  = creator_categories(:writer)
    end



    # CAN
    # ============================================================
    test "should create connection" do
      sign_in @randa

      count = @poem.creator_categories.size

      assert_equal 0, @poem.creator_categories(:reload).size
      post :create, describer_id: @poem.id, creator_id: @writer.id, format: 'js'

      assert_not_nil assigns(:describer)
      assert_not_nil assigns(:creator_category)
      assert_equal count + 1, assigns(:describer).creator_categories(:reload).size
    end

    test "should destroy connection" do
      sign_in @randa
      count = @article.creator_categories.size

      delete :destroy, describer_id: @article.id, creator_id: @writer.id, format: 'js'

      assert_not_nil assigns(:describer)
      assert_not_nil assigns(:creator_category)
      assert_equal count - 1, assigns(:describer).creator_categories(:reload).size
    end



    # CANNOT
    # ============================================================
    test "should redirect" do
      sign_in @sirka
      post :create, describer_id: @poem.id, creator_id: @writer.id
      assert_redirected_to root_path
    end

  end
end