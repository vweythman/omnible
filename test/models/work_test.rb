require 'test_helper'

class WorkTest < ActiveSupport::TestCase
  setup do
    @work = works(:flight)
    @alt_work = works(:fool)
  end

  test "heading should be the same as title" do
  	assert_equal @work.title, @work.heading
  end

  test "should have appearances" do
  	assert_equal 3, @work.appearances.length
  end

end
