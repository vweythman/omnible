require 'test_helper'
module Works
  module Branches
    class BranchingsControllerTest < ControllerTestCase

      # SETUP
      # ============================================================
      setup do
        # Users
        @indra = users(:indra)
        @amiya = users(:amiya)

        # Branch
        @branching = branchings(:h1)
        @hope1 = branches(:hope1)
        @hope2 = branches(:hope2a)
        @hope3 = branches(:hope3a)
      end

      # CAN
      # ============================================================
      # UPDATE
      # ------------------------------------------------------------
      test "should get edit" do
        sign_in @indra

        post :edit, id: @branching.id

        assert assigns(:branching)
      end

      test "should update" do
        sign_in @indra

        post :update, id: @branching.id, branching: { child_node_id: @hope2.id }

        assert_equal @hope2, assigns(:branching).child_node
      end

    end
  end
end
