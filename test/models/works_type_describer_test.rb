require 'test_helper'

class WorksTypeDescriberTest < ActiveSupport::TestCase

  # SETUP
  # ============================================================
  setup do
    # DESCRIBERS
    @article     = works_type_describers(:article)
    @journal     = works_type_describers(:journal)
    @poem        = works_type_describers(:poem)
    @short_story = works_type_describers(:short_story)
    @story       = works_type_describers(:story)
    @story_link  = works_type_describers(:story_link)

    # CATEGORIES
    @author     = creator_categories(:author)
    @editor     = creator_categories(:editor)
    @translator = creator_categories(:translator)
    @writer     = creator_categories(:writer)
  end

  # TESTS :: PUBLIC METHODS
  # ============================================================
  # ACTIONS
  # ------------------------------------------------------------
  test "should agentize" do
    assert_not @story.creator_categories.include? @editor

    @story.agentize @editor

    assert @story.creator_categories.include? @editor
  end

  test "should deagentize" do
    assert @article.creator_categories.include? @editor

    @article.deagentize @editor

    assert_not @article.creator_categories.include? @editor
  end

  # GETTERS
  # ------------------------------------------------------------
  test "should get heading" do
    assert_equal "ShortStory", @short_story.name
    assert_equal "Short Story", @short_story.heading
  end

  # QUESTIONS
  # ------------------------------------------------------------
  test "should be narrative" do
    assert @story.narrative?
    assert @poem.narrative?
    assert @short_story.narrative?
    assert @story_link.narrative?
  end

  test "should not be narrative" do
    assert_not @article.narrative?
    assert_not @journal.narrative?
  end

  test "should be record" do
    assert @story_link.narrative?
  end

  test "should not be record" do
    assert_not @story.narrative?
  end

end