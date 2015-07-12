require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @cinders = users(:cinders)
    @randa   = users(:randa)
    @sirka   = users(:sirka)
  end

  test "should have friendships" do
  	assert @randa.friend? @sirka
  	assert @sirka.friend? @randa

  	assert @cinders.friend? @randa
    assert_not @randa.friend? @cinders

    assert_not @sirka.friend? @cinders
    assert_not @cinders.friend? @sirka
  end

  test "should have mutual friends" do
  	assert @randa.mutual_friend? @sirka
    assert @sirka.mutual_friend? @randa

    assert_not @sirka.mutual_friend? @cinders
    assert_not @cinders.mutual_friend? @sirka

    assert_not @randa.mutual_friend? @cinders
  	assert_not @cinders.mutual_friend? @randa
  end

  test "should have followers" do
  	assert_not @sirka.following? @randa
  	assert_not @randa.following? @sirka

  	assert @randa.following? @cinders
  	assert_not @cinders.following? @randa

  	assert_not @cinders.following? @sirka
  	assert_not @sirka.following? @cinders
  end

  test "should have blocked users" do
    assert @sirka.blocking? @cinders
    assert @cinders.blocking? @sirka
    assert_not @sirka.blocking? @randa
  end

  test "should be following other users" do
  end

end
