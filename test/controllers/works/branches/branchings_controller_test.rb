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
        @branching1 = branchings(:h1)
        @branching2 = branchings(:h3)

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

        post :edit, id: @branching1.id

        assert assigns(:branching)
      end

      test "should update" do
        sign_in @indra

        post :update, id: @branching1.id, branching: { child_node_id: @hope2.id }

        assert_equal @hope2, assigns(:branching).child_node
      end

      # DESTROY
      # ------------------------------------------------------------
      test "should destroy" do
        sign_in @indra
        assert_difference('Branching.count', -1) do
          delete :destroy, id: @branching2.id
        end
      end

      # CANNOT
      # ============================================================
      # DESTROY
      # ------------------------------------------------------------
      test "should not destroy" do
        sign_in @indra
        assert_no_difference('Branching.count', -1) do
          delete :destroy, id: @branching1.id
        end
      end

    end
  end
end
