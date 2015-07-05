require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  
  setup do
    @activity = activities(:seek)
  end

  test "should not be subject" do
    assert_not @activity.is_subject?
  end

  test "heading should equal name" do
  	assert_same @activity.name, @activity.heading
  end
end
