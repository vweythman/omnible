require 'test_helper'

class RatingTest < ActiveSupport::TestCase

  # SETUP
  # ============================================================
  setup do
    # SHORT STORIES
    @calypso = works(:calypso) # V => 3 | S => 2 | P => 2
    @effaces = works(:effaces) # V => 0 | S => 0 | P => 0
    @glamour = works(:glamour) # V => 2 | S => 1 | P => 1

    # CHAPTERED STORIES
    @heart  = works(:heart)  # V => 1 | S => 0 | P => 1
    @helix  = works(:helix)  # V => 2 | S => 4 | P => 4
    @frenzy = works(:frenzy) # V => 3 | S => 1 | P => 3
  end

  # CLASS FUNCTION
  # ============================================================
  test "should get works with ratings between minor and major" do
    arr = Work.assort(:rating_min => 1, :rating_max => 3)

    assert arr.include? @heart
    assert arr.include? @glamour
    assert arr.include? @calypso
    assert arr.include? @frenzy

    assert_not arr.include? @effaces
    assert_not arr.include? @helix
  end

  test "should get works with one rating" do
    arr = Work.assort(:vrating => 3)

    assert arr.include? @calypso
    assert arr.include? @frenzy

    assert_not arr.include? @effaces
    assert_not arr.include? @helix
    assert_not arr.include? @heart
    assert_not arr.include? @glamour
  end

  test "should get works with two ratings" do
    arr = Work.assort(:vrating => 2, :prating => 1)

    assert arr.include? @glamour

    assert_not arr.include? @frenzy
    assert_not arr.include? @effaces
    assert_not arr.include? @helix
    assert_not arr.include? @heart
    assert_not arr.include? @calypso
  end

  test "should get works with three ratings" do
    arr = Work.assort(:vrating => 2, :prating => 4, :srating => 4)

    assert arr.include? @helix

    assert_not arr.include? @frenzy
    assert_not arr.include? @effaces
    assert_not arr.include? @glamour
    assert_not arr.include? @heart
    assert_not arr.include? @calypso
  end

  # PUBLIC FUNCTION
  # ============================================================
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

end
