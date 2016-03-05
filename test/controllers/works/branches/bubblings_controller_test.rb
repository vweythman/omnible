require 'test_helper'
module Works
  module Branches
    class BubblingsControllerTest < ControllerTestCase

      # SETUP
      # ============================================================
      setup do
        # Users
        @sirka = users(:sirka)
        @amiya = users(:amiya)

        # Branch
        @aqua1 = branches(:aqua1)
      end

      # CAN
      # ============================================================
      # CREATE
      # ------------------------------------------------------------
      test "should create new branch" do
        sign_in @sirka

        assert_difference('Branch.count') do
          post :create, branch_id: @aqua1.id, branching: {
            heading: "head over here",
            child_node_attributes: {
              title: "this is a title",
              content: "lorem ipsum"
            }
          }
        end

        assert assigns(:parent_branch)
        assert assigns(:branching)
      end

    end
  end
end