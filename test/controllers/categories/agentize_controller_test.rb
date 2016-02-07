require 'test_helper'

module Categories
  class AgentizeControllerTest < ControllerTestCase
    setup do
      @letty   = users(:letty)
      @randa   = users(:randa)

      @poem    = works_type_describers(:poem)
      @article = works_type_describers(:article)
      
      @writer  = creator_category(:writer)
    end

    test "should redirect" do
      sign_in @letty
      post :create, describer_id: @poem.id, creator_id: @writer.id
      assert_redirected_to root_path
    end

    test "should create connection" do
      sign_in @randa
      post :create, describer_id: @poem.id, creator_id: @writer.id, format: 'js'
    end

    test "should destroy connection" do
      sign_in @randa
      post :destroy, describer_id: @poem.id, creator_id: @writer.id, format: 'js'
    end

  end
end