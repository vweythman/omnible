require 'test_helper'

module Subjects
  module Curation
    class WorkCharactersControllerTest < ControllerTestCase

      setup do
        @work = works(:frenzy)
      end

      test "should get index" do
        get :index, work_id: @work

        assert_response :success
        assert_not_nil assigns(:parent)
        assert_not_nil assigns(:characters)
        assert_not_nil assigns(:subjects)
        assert_equal assigns(:characters), assigns(:subjects)
      end

    end
  end
end