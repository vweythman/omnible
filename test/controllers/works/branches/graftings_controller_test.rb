require 'test_helper'
module Works
  module Branches
    class GraftingsControllerTest < ControllerTestCase

      # SETUP
      # ============================================================
      setup do
        # Users
        @indra = users(:indra)
        @amiya = users(:amiya)

        # Branch
        @hope1 = branches(:hope1)
        @hope2 = branches(:hope2a)
        @hope3 = branches(:hope3a)
      end

      # CAN
      # ============================================================
      # CREATE
      # ------------------------------------------------------------
      test "should create new branching" do
        sign_in @indra

        assert_difference('Branching.count') do
          post :create, branch_id: @hope1.id, branching: {
            heading: "head over here",
            child_node_id: @hope3.id
          }
        end

        assert assigns(:parent_branch)
        assert assigns(:branching)
        assert_not assigns(:parent_branch).unlinked? assigns(:child_branch)
      end

    end
  end
end
