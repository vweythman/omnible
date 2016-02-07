require 'test_helper'

class RatingTest < ActiveSupport::TestCase
  setup do
    # SHORT STORIES
    @calypso = works(:calypso)
    @effaces = works(:effaces)
    @glamour = works(:glamour)

    # CHAPTERED STORIES
    @heart  = works(:heart)
    @helix  = works(:helix)
    @frenzy = works(:frenzy)
  end

  test "should have lowest rating" do
    assert_equal 0, @effaces.rating.max
    assert_equal "Absent", @effaces.rated
  end

  test "should have low rating" do
    assert_equal 1, @heart.rating.max
    assert_equal "Minor", @heart.rated
  end

  test "should have medium rating" do
    assert_equal 2, @glamour.rating.max
    assert_equal "Medium", @glamour.rated
  end

  test "should have high rating" do
    assert_equal 3, @calypso.rating.max
    assert_equal "Major", @calypso.rated
    
    assert_equal 3, @frenzy.rating.max
    assert_equal "Major", @frenzy.rated
  end

  test "should have highest rating" do
    assert_equal 4, @helix.rating.max
    assert_equal "Explicit", @helix.rated
  end

  test "should get works with ratings between minor and major" do
    arr = Work.assort(:rating_min => 1, :rating_max => 3)
    assert arr.include? @heart
    assert arr.include? @glamour
    assert arr.include? @calypso
    assert arr.include? @frenzy

    assert_not arr.include? @effaces
    assert_not arr.include? @helix
  end

end
