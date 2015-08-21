require 'test_helper'

class StoryTest < ActiveSupport::TestCase
  setup do
    @flight = works(:flight)
    @baffle = works(:baffle)
  end
  
  test "should start chapters at 1" do
    story = Story.new
    assert_equal 1, story.newest_chapter_position
  end

end
