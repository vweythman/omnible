require 'test_helper'

module Subjects
  module Curation
    class WorkCharactersControllerTest < ControllerTestCase

      setup do
        @frenzy  = works(:frenzy)
        @glamour = works(:glamour)
      end

      test "should get index" do
        get :index, work_id: @glamour.id

        assert_response :success
        assert_not_nil assigns(:parent)
        assert_not_nil assigns(:characters)
        assert_not_nil assigns(:subjects)
        assert_equal assigns(:characters), assigns(:subjects)
      end

      test "should get not index" do
        get :index, work_id: @frenzy.id

        assert_redirected_to root_path
      end

    end
  end
end