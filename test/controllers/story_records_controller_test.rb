require 'test_helper'

module Works
  class StoryRecordsControllerTest < ControllerTestCase

    setup do
      @baffle = works(:baffle)
    end

    test "should get index" do
      get :index
      assert_response :success
    end

    test "should get show" do
      get :show, :id => @baffle.id
      assert_response :success
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should get edit" do
      get :edit, :id => @baffle.id
      assert_response :success
    end

  end
end