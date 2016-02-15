require 'test_helper'

module Works
  module Curation
    class TagWorksControllerTest < ControllerTestCase

      setup do
        @tag       = tags(:magic_returns)
        @glamour   = works(:glamour)
        @rainfalls = works(:rainfalls)
      end

      test "should get index" do
        get :index, tag_id: @tag.id

        assert_response :success

        assert_not_nil assigns(:parent)
        assert_not_nil assigns(:works)

        assert assigns(:works).include?(@glamour), assigns(:works).map(&:title)
        assert_not assigns(:works).include? @rainfalls
      end

    end
  end
end