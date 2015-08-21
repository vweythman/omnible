require 'test_helper'

class WorkTest < ActiveSupport::TestCase
  setup do
    @flight = works(:flight)
    @baffle = works(:baffle)
  end

  test "heading should be the same as title" do
  	assert_equal @flight.title, @flight.heading
  end

end
