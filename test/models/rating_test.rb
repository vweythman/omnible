require 'test_helper'

class RatingTest < ActiveSupport::TestCase
  setup do
    @flight = works(:flight)
    @baffle = works(:baffle)
    @offend = works(:offend)
    @attend = works(:attend)
    @frenzy = works(:frenzy)
  end

  test "should be rated absent" do
    assert_equal 0, @flight.rating.max
    assert_equal "Absent", @flight.rated
  end

  test "should be rated minor" do
    assert_equal 1, @baffle.rating.max
    assert_equal "Minor", @baffle.rated
  end

  test "should be rated medial" do
    assert_equal 2, @attend.rating.max
    assert_equal "Medial", @attend.rated
  end

  test "should be rated major" do
    assert_equal 3, @frenzy.rating.max
    assert_equal "Major", @frenzy.rated
  end

  test "should be rate explicit" do
    assert_equal 4, @offend.rating.max
    assert_equal "Explicit", @offend.rated
  end

  test "should get works with ratings between minor and major" do
    arr = Work.assort(:rating_min => 1, :rating_max => 3)
    assert arr.include? @baffle
    assert arr.include? @attend
    assert arr.include? @frenzy

    assert_not arr.include? @flight
    assert_not arr.include? @offend
  end

end
