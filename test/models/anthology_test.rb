require 'test_helper'

class AnthologyTest < ActiveSupport::TestCase
  
  setup do
    @anthology = anthologies(:folktales)
  end

  test "heading should equal name" do
  	name = "jumping"
  	@anthology.name = name

  	assert_match @anthology.heading, name
  end
end
