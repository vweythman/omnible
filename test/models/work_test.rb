require 'test_helper'

class WorkTest < ActiveSupport::TestCase
  setup do
    @heart = works(:heart)
  end

  test "heading should be the same as title" do
  	assert_equal @heart.title, @heart.heading
  end

end
