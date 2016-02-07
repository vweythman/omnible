require 'test_helper'

class AppearanceTest < ActiveSupport::TestCase

  setup do
    @effaces  = works(:effaces)  # narrative
    @theocrat = works(:theocrat) # non-narrative
  end

  test "should generate roles for a narrative story" do
    roles = Appearance.roles(@effaces)
    assert roles.include? 'main'
    assert roles.include? 'side'
    assert roles.include? 'mentioned'
    assert_not roles.include? 'subject'
    assert_equal 3, roles.length
  end

  test "should generate roles for non narrative story" do
    roles = Appearance.roles(@theocrat)
    assert roles.include? 'subject'
    assert_not roles.include? 'main'
    assert_not roles.include? 'side'
    assert_not roles.include? 'mentioned'
    assert_equal 1, roles.length
  end

  test "should generate roles hash" do
    h = Appearance.roles_by_type(@effaces.narrative?)
    assert_equal 3, h.length, h
  end

end
