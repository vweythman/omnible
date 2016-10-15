require 'test_helper'

class ChapterTest < ActiveSupport::TestCase

  setup do
    # Short Stories
    @calypso = works(:calypso)
    @effaces = works(:effaces)
    @glamour = works(:glamour)

    # Chaptered Stories
    @heart  = works(:heart)
    @helix  = works(:helix)
    @frenzy = works(:frenzy)

    # Short Story Content
    @calypso_content = chapters(:calypso_content)
    @effaces_content = chapters(:effaces_content)
    @glamour_content = chapters(:glamour_content)

    # Chapters
    @heart_zero  = chapters(:heart_zero)
    @helix_one   = chapters(:helix_one)
    @helix_two   = chapters(:helix_two)
    @frenzy_zero = chapters(:frenzy_zero)
  end

  # CLASS METHODS TESTS
  # ============================================================
  test "should switch positions" do
    pos1 = @helix_one.position
    pos2 = @helix_two.position

    Chapter.swap_positions(@helix_one, @helix_two)
    
    # positions
    assert_equal pos2, @helix_one.position
    assert_equal pos1, @helix_two.position

    # old positions
    assert_not_equal pos1, @helix_one.position
    assert_not_equal pos2, @helix_two.position
  end

  test "should not allow chapters of different stories to swap" do
    assert_not Chapter.swap_positions(@helix_one, @frenzy_zero)
  end

  # PUBLIC METHODS TESTS
  # ============================================================
  # GETTERS
  # ------------------------------------------------------------
  test "should have position in default heading" do
    # has title
    assert_equal "Chapter 1", @helix_one.default_heading
  end

  test "should count chapter length" do
    # content: The island ate them piece by piece.
    assert_equal 7, @effaces_content.word_count
    
    # content: "You will fail and find nothing." The Raven said. "I will succeed and find everything." The girl answered.
    assert @helix_two.word_count < 19
    assert @helix_two.word_count > 17

    # content: A twist. A turn. They did not meet.
    assert_equal 8, @heart_zero.word_count
  end

  # SETTERS
  # ------------------------------------------------------------
  test "should get next" do
    assert_equal @helix_two, @helix_one.next
    assert_not_equal @heart_zero, @helix_one.next
  end

  test "should get prev" do
    assert_equal @helix_one, @helix_two.prev
    assert_not_equal @helix_two, @helix_two.prev
  end

  # ACTIONS
  # ------------------------------------------------------------
  test "should create space after" do
    @helix_one.make_room
    assert_not_equal 2, @helix_two
  end

  test "should insert as first chapter" do
    chapter         = Chapter.new
    chapter.content = "this is not that important"
    chapter.story   = @helix

    assert chapter.place_first
    assert chapter.save
    assert_equal 1, chapter.position
  end

  test "should insert after a chapter within existing chapters" do
    # setup values
    new_chapter = @helix.new_chapter
    old_pos     = @helix_two.position
    new_pos     = old_pos + 1

    @helix_one.make_room
    @helix_two.reload
    assert new_chapter.place_after @helix_one, true

    assert_not_equal old_pos, @helix_two.position
    assert_equal     new_pos, @helix_two.position
    assert_equal     old_pos, new_chapter.position
   
    new_chapter.content = "XX blah"
    assert new_chapter.save

    # check without making room first
    next_pos = @helix_two.position + 1

    assert new_chapter.place_after @helix_two
    assert new_chapter.save
    assert_equal next_pos, new_chapter.position
  end

  test "should insert before a chapter within existing chapters" do
    new_chapter = @helix.new_chapter
    new_chapter.content = "XX blah"
    chap_pos = @helix_two.position

    assert new_chapter.place_before @helix_two
    assert new_chapter.save
    assert_equal chap_pos, new_chapter.position
  end

  # PRIVATE METHODS TESTS
  # ============================================================
  test "should set position upon create" do
    new_position = @helix.newest_chapter_position
    new_chapter  = Chapter.create(title: 'New End', content: "Not Important", story_id: @helix.id)
    assert_equal new_position, new_chapter.position
  end

  test "should not insert chapter amongst chapters of a different work" do
    assert_not @helix.new_chapter.place_after @frenzy_zero
  end

  test "should create valid position" do
    position        = @helix.newest_chapter_position
    new_chapter     = Chapter.create(title: 'The Real End This Time', content: "Blah x 2", position: position, story_id: @helix.id)
    newest_position = @helix.newest_chapter_position
    assert_not_equal newest_position, new_chapter.position
  end

end
