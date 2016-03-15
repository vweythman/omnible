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
    @record      = works(:do)
  end

  # TESTS :: CLASS METHODS
  # ============================================================
  test "should find or batch by title" do
    title = "Fire and Ice [Poem] / Robert Frost"
    work = Work.batch_by_title(title, @article.uploader).first

    assert Work.all.include? work
    assert work.creators.pluck(:name).include?( "Robert Frost")
    assert work.metadata.pluck(:value).include? "Poem"
  end

  test "should find by title proper" do
    assert_equal @article,     Work.find_by_title_proper("Happiness Meta / indra's pen")
    assert_equal @journal,     Work.find_by_title_proper("Measure of Rainfall")
    assert_equal @short_story, Work.find_by_title_proper("Fate of Fortune [Short Story]")
    assert_not Work.find_by_title_proper("Fire and Ice")
  end

  test "should determine title from title proper" do
    assert_equal "Fire and Ice", Work.find_heading_by( "Fire and Ice" )
    assert_equal "Fire and Ice", Work.find_heading_by( "Fire and Ice / Robert Frost" )
    assert_equal "Fire and Ice", Work.find_heading_by( "Fire and Ice [Poem] / Robert Frost" )
    assert_equal "Fire & Ice",   Work.find_heading_by( "Fire & Ice")
  end

  test "should grab type from title proper" do
    assert_equal "Poem", Work.find_type_by( "Fire and Ice [Poem] / Robert Frost" )
    assert_equal "Film", Work.find_type_by( "Star Wars: New Hope [Film]")
    assert_not Work.find_type_by( "Fire and Ice" )
  end

  test "should grab creator name from title proper" do
    assert_equal "Robert Frost", Work.find_creator_name_by( "Fire and Ice [Poem] / Robert Frost" )
    assert_equal "Tom Siddell", Work.find_creator_name_by( "Gunnerkrigg Court / Tom Siddell" )
    assert_not Work.find_creator_name_by( "Fire and Ice" )
  end

  # TESTS :: PUBLIC METHODS
  # ============================================================
  # GETTERS
  # ------------------------------------------------------------
  test "should use title for heading" do
  	assert_equal @story.title, @story.heading
  end

  # QUESTIONS
  # ------------------------------------------------------------
  test "should be complete" do
    assert @article.complete?
    assert @short_story.complete?
  end

  test "should humanize type" do
    assert_equal "Film", @record.medium
    assert_equal "Short Story", @short_story.categorized_type
  end

end
