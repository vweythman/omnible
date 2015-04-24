require 'test_helper'

class AppearanceTest < ActiveSupport::TestCase
  setup do
    @main = appearances(:main)
    @side = appearances(:side)
    @mentioned = appearances(:mentioned)
  end

  test "should have work" do
  	assert_not @main.work.nil?
  end

  test "should have character" do
  	assert_not @main.character.nil?
  end
end
