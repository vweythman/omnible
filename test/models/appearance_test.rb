require 'test_helper'

class AppearanceTest < ActiveSupport::TestCase

  setup do
    @flight = works(:flight) # narrative
    @offend = works(:offend) # non-narrative
  end

  test "should generate roles for a narrative story" do
    roles = Appearance.roles(@flight)
    assert roles.include? 'main'
    assert roles.include? 'side'
    assert roles.include? 'mentioned'
    assert_equal 3, roles.length
  end

  test "should generate roles for non narrative story" do
    roles = Appearance.roles(@offend)
    assert roles.include? 'subject'
    assert roles.include? 'appearing'
    assert roles.include? 'mentioned'
    assert_equal 3, roles.length
  end

  test "should generate roles hash" do
    h = Appearance.init_hash(@flight)
    assert_equal 3, h.length, h

  end

end
