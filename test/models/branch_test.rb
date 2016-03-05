require 'test_helper'

class BranchTest < ActiveSupport::TestCase

  setup do
    @hope = works(:hope)
    @aqua = works(:aqua)
    @zinc = works(:zinc)

    @hope1 = branches(:hope1)
    @hope2 = branches(:hope2a)
    @hope3 = branches(:hope3a)
    @aqua1 = branches(:aqua1)
  end

  # TESTS :: PUBLIC METHODS
  # ============================================================
  # ACTIONS
  # ------------------------------------------------------------
  test "should bubble new branch" do
    branching = @aqua1.bubble("head over here")
    branching.child_node.title   = "test"
    branching.child_node.content = "also test"

    branching.save
    @aqua1.reload

    assert_equal @aqua1.story, branching.child_node.story
    assert_not @aqua1.unlinked? branching.child_node
  end

  test "should bubble a branch (method 2)" do
    branch_values = {
      heading: "head over here",
      child_node_attributes: {
        title: "this is a title",
        content: "lorem ipsum"
      }
    }

    branching = @aqua1.child_branchings.new(branch_values)

    branching.save
    @aqua1.reload

    assert_equal @aqua1.story, branching.child_node.story
    assert_not @aqua1.unlinked? branching.child_node
  end

  test "should graft branches" do
    branching = @hope1.graft("Head over there", @hope3)
    branching.save

    @hope1.reload
    @hope3.reload

    assert @hope1.child_nodes.include? @hope3
  end

  test "should plant branch" do
    branching = @hope1.plant("Head over there", @hope3)
    branching.save

    @hope1.reload
    @hope3.reload

    assert @hope3.child_nodes.include? @hope1
  end

  # QUESTIONS
  # ------------------------------------------------------------
  test "should be graftable" do
    assert @hope1.can_graft_to? @hope3
    assert @hope1.can_graft_to? @hope1
    assert @hope3.can_graft_to? @hope3
  end

  test "should not be graftable" do
    assert_not @hope1.can_graft_to? @hope2
    assert_not @hope1.can_graft_to? @aqua1
  end

  test "should share story" do
    assert @hope1.shares_story_with? @hope3
  end

  test "should not share story" do
    assert_not @hope1.shares_story_with? @aqua1
  end

  test "should be linked" do
    assert_not @hope1.unlinked? @hope2
  end

  test "should not be linked" do
    assert @hope1.unlinked? @hope3
  end

end
