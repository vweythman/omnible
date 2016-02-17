require 'test_helper'

class WorkTest < ActiveSupport::TestCase

  # SETUP
  # ============================================================
  setup do
    @article     = works(:skywalks)
    @journal     = works(:rainfalls)
    @story       = works(:frenzy)
    @short_story = works(:calypso)
    @story_link  = works(:zoologist)
  end

  # TESTS :: CLASS METHODS
  # ============================================================

  # TESTS :: PUBLIC METHODS
  # ============================================================
  # GETTERS
  # ------------------------------------------------------------
  test "heading should be the same as title" do
  	assert_equal @heart.title, @heart.heading
  end

  # QUESTIONS
  # ------------------------------------------------------------
  test "should be complete" do
    assert @article.complete?
    assert @short_story.complete?
  end

end
