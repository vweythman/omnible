require 'test_helper'

class RecordQuantitativeMetadatumTest < ActiveSupport::TestCase

  setup do
    @record = works(:do)
    @story  = works(:helix)
  end

  # STORY METADATA
  test "should find chapter count" do
    @story.update_counter
    assert_equal 2, @story.quantitatives.datum("chapter-count").value
  end

  test "should update chapter count on delete" do
    @story.chapters.ordered.last.destroy
    assert_equal 1, @story.chapters.count
    assert_equal 1, @story.quantitatives.datum("chapter-count").value
  end

end
