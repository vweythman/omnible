require 'test_helper'

class AnthologyTest < ActiveSupport::TestCase
  setup do
    @anthology = activities(:one)
  end

  test "should not save without name" do
  	anthology = Activity.new
  	assert_not anthology.save
  end

  test "heading should equal name" do
  	name = "jumping"
  	@anthology.name = name

  	assert_same @anthology.heading, name
  end
end
