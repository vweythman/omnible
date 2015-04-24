require 'test_helper'

class ChapterTest < ActiveSupport::TestCase
  setup do
    # chapters of the same work
    @first  = chapters(:flight_one)
    @second = chapters(:flight_two)
  end

  test "should have work" do
    @first.work = nil
    assert_not @first.save
  end

  test "should have content" do
    @first.content = nil
    assert_not @first.content
  end

  test "should have uniq position" do
    @second.position = @first.position
    assert_not @second.save
  end

  test "should create valid position" do
    @second.position = Chapter.newest_position(@first.work)
    assert @second.save
  end

  test "next position should be greater than previous" do
    pos1 = Chapter.newest_position(@second.work)
    assert pos1 > @second.position
  end

  test "chapters of the same work should create same latest position" do
    pos1 = Chapter.newest_position(@first.work)
    pos2 = Chapter.newest_position(@second.work)
    assert_equal pos1, pos2
  end

  test "should start position at 1" do
    @work = works(:fool)
    pos1  = Chapter.newest_position(@work)
    assert_equal 1, pos1
  end

end
