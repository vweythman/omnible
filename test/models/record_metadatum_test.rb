require 'test_helper'

class RecordMetadatumTest < ActiveSupport::TestCase

  setup do
    @record = works(:do)
    @story  = works(:helix)

    @story_chapter1 = chapters(:helix_one)
    @story_chapter2 = chapters(:helix_two)
  end

  # STORY METADATA
  test "should find first chapter id" do
    assert_equal @story_chapter1.id, @story.qualitatives.datum("first-chapter").value.to_i
  end

  test "should find last chapter id" do
    assert_equal @story_chapter2.id, @story.qualitatives.datum("lastest-chapter").value.to_i
  end

  # RECORD METADATA
  test "should find medium datum" do
    assert_equal "Film", @record.qualitatives.datum("medium").value
  end

end
