require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  setup do
    @activity = activities(:one)
  end

  test "should not be subject" do
    assert_not @activity.is_subject?
  end

  test "should not save without name" do
  	activity = Activity.new
  	assert_not activity.save
  end

  test "heading should equal name" do
  	assert_same @activity.name, @activity.heading
  end
end
