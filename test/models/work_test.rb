require 'test_helper'

class WorkTest < ActiveSupport::TestCase
  setup do
    @flight = works(:flight)
    @fool   = works(:fool)
  end

  test "heading should be the same as title" do
  	assert_equal @flight.title, @flight.heading
  end

  test "should start chapters at 1" do
    work = Work.new
    assert_equal 1, work.newest_chapter_position
  end

end
