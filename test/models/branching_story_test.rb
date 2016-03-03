require 'test_helper'

class BranchingStoryTest < ActiveSupport::TestCase
  setup do
    @hope = works(:hope)
    @aqua = works(:aqua)
    @zinc = works(:zinc)

    @hope1 = branches(:hope1)
  end
  
  # TESTS :: CLASS METHODS
  # ============================================================
  test "should sort by average branching" do
    story_titles = BranchingStory.order_by("average-branchings").pluck(:title)
    assert_equal @hope.title, story_titles.first
    assert_equal @aqua.title, story_titles.last
  end

  test "should sort number of branches" do
    stories = BranchingStory.order_by("branches-count")
    assert_equal @hope, stories.first
    assert_equal @aqua, stories.last
  end

  # TESTS :: PUBLIC METHODS
  # ============================================================
  test "should get average branching" do
    assert_equal 2.0, @zinc.average_branching
  end

  test "should start count at one or greater" do
    assert_equal 0, @aqua.parent_nodes.count
    assert_equal 1, @aqua.parentable_node_count

    assert_equal 3, @hope.parent_nodes.count
    assert_equal 3, @hope.parentable_node_count
  end

  test "should have starting branch" do
    assert_equal @hope1, @hope.trunk
  end
end
