require 'test_helper'

class ChapterTest < ActiveSupport::TestCase
  
  setup do
    @flight = works(:flight) # Chaptered Story
    @offend = works(:offend) # Short Story
    @flight_one = chapters(:flight_one)
    @flight_two = chapters(:flight_two)
    @offend_zro = chapters(:offend_titleless)
  end

  test "should have story" do
    assert_equal @flight, @flight_one.story
    assert_equal @offend, @offend_zro.story
  end

  test "should build headings through title and position" do
    # has title
    assert_equal "Prologue", @flight_one.heading
    assert_equal "Chapter 1 - Prologue", @flight_one.complete_heading

    # does not have a title
    assert_equal "Chapter 1", @offend_zro.heading
    assert_equal "Chapter 1", @offend_zro.complete_heading
  end

  test "should count chapter length" do
    # content: blah blah A.C.M.E.
    assert_equal 3, @flight_one.word_count
    
    # content: blah's blah
    assert @flight_two.word_count < 3
    assert @flight_two.word_count > 1

    # content: blah blah blah. and also blah
    assert_equal 6, @offend_zro.word_count
  end

  test "should get next" do
    assert_equal @flight_two, @flight_one.next
    assert_not_equal @flight_one, @flight_one.next
  end

  test "should get prev" do
    assert_equal @flight_one, @flight_two.prev
    assert_not_equal @flight_two, @flight_two.prev
  end

  test "chapter has a discussion" do
    chapter = @flight.new_chapter
    assert chapter.topic.nil?

    chapter.set_discussion
    assert_not chapter.topic.nil?
  end

  test "chapter creates a discussion upon create" do
    chapter         = @flight.new_chapter
    chapter.content = "XX blah"
    assert chapter.save
    assert_not chapter.topic.nil?
  end

  test "should only create one discussion" do
    chapter         = @flight.new_chapter
    chapter.content = "Ignore this"
    assert chapter.save
    
    chapter.set_discussion
    assert chapter.save

    topics = Topic.where(discussed_type: "Chapter", discussed_id: chapter.id)
    assert_equal 1, topics.length
  end

  test "should set position upon create" do
    new_position = @flight.newest_chapter_position
    new_chapter  = Chapter.create(title: 'New End', content: "Not Important", story_id: @flight.id)
    assert_equal new_position, new_chapter.position
  end

  test "should insert as first chapter" do
    chapter         = Chapter.new
    chapter.content = "this is not that important"
    chapter.story   = @flight

    assert chapter.place_first
    assert chapter.save
    assert_equal 1, chapter.position
  end

  test "should not insert chapter amongst chapters of a different work" do
    assert_not @flight.new_chapter.place_after @offend_zro
  end

  test "should insert chapter within existing chapters" do
    # setup values
    new_chapter = @flight.new_chapter
    old_pos     = @flight_two.position
    new_pos     = old_pos + 1

    @flight_one.make_room
    @flight_two.reload
    assert new_chapter.place_after @flight_one, true

    assert_not_equal old_pos, @flight_two.position
    assert_equal     new_pos, @flight_two.position
    assert_equal     old_pos, new_chapter.position
   
    new_chapter.content = "XX blah"
    assert new_chapter.save

    # check without making room first
    next_pos = @flight_two.position + 1

    assert new_chapter.place_after @flight_two
    assert new_chapter.save
    assert_equal next_pos, new_chapter.position
  end

  test "should create valid position" do
    position        = @flight.newest_chapter_position
    new_chapter     = Chapter.create(title: 'The Real End This Time', content: "Blah x 2", position: position, story_id: @flight.id)
    newest_position = @flight.newest_chapter_position
    assert_not_equal newest_position, new_chapter.position
  end

  test "should swap positions" do
    pos1 = @flight_one.position
    pos2 = @flight_two.position

    Chapter.swap_positions(@flight_one, @flight_two)
    
    # positions
    assert_equal pos2, @flight_one.position
    assert_equal pos1, @flight_two.position

    # old positions
    assert_not_equal pos1, @flight_one.position
    assert_not_equal pos2, @flight_two.position
  end

end
