require 'test_helper'

module Subjects
  module Curation
    class IdentityCharactersControllerTest < ControllerTestCase

      setup do
        @identity = identities(:young)
      end

      test "should get index" do
        get :index, identity_id: @identity

        assert_response :success
        assert_not_nil assigns(:parent)
        assert_not_nil assigns(:characters)
        assert_not_nil assigns(:subjects)
        assert_equal assigns(:characters), assigns(:subjects)
      end

    end
  end
end