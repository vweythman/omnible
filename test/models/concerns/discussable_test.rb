require 'test_helper'

class DiscussableTest < ActiveSupport::TestCase

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

  test "chapter has a discussion" do
    chapter = @heart.new_chapter
    assert chapter.topic.nil?

    chapter.set_discussion
    assert_not chapter.topic.nil?
  end

  test "chapter creates a discussion upon create" do
    chapter         = @heart.new_chapter
    chapter.content = "XX blah"
    assert chapter.save
    assert_not chapter.topic.nil?
  end

  test "should only create one discussion" do
    chapter         = @heart.new_chapter
    chapter.content = "Ignore this"
    assert chapter.save
    
    chapter.set_discussion
    assert chapter.save

    topics = Topic.where(discussed_type: "Chapter", discussed_id: chapter.id)
    assert_equal 1, topics.length
  end

end