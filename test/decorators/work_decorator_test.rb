require 'test_helper'

class WorkDecoratorTest < Draper::TestCase

  # SETUP
  # ============================================================
  setup do
    @article     = works(:skywalks).decorate
    @journal     = works(:rainfalls).decorate
    @story       = works(:frenzy).decorate
    @short_story = works(:glamour).decorate
    @story_link  = works(:zoologist).decorate
    @record      = works(:do).decorate
  end

  # TESTS :: PUBLIC METHODS
  # ============================================================
  test "should get characters by role" do
    potential_labels = Appearance.narrative_labels

    used_labels      = @story.cohorted_characters.keys
    assert (potential_labels & used_labels).length > 0
  end

  test "should get works by group" do
    potential_labels = WorkConnection.narrative_labels
    used_labels      = @short_story.organized_works.keys

    assert (potential_labels & used_labels).length > 0
  end

end
