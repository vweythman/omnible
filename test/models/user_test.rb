require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @amiya = users(:amiya)
    @randa = users(:randa)
    @sirka = users(:sirka)
  end

  test "should have friendships" do
  	assert @randa.friend? @sirka
  	assert @sirka.friend? @randa

  	assert @amiya.friend? @randa
    assert_not @randa.friend? @amiya

    assert_not @sirka.friend? @amiya
    assert_not @amiya.friend? @sirka
  end

  test "should have mutual friends" do
  	assert @randa.mutual_friend? @sirka
    assert @sirka.mutual_friend? @randa

    assert_not @sirka.mutual_friend? @amiya
    assert_not @amiya.mutual_friend? @sirka

    assert_not @randa.mutual_friend? @amiya
  	assert_not @amiya.mutual_friend? @randa
  end

  test "should have followers" do
  	assert_not @sirka.following? @randa
  	assert_not @randa.following? @sirka

  	assert @randa.following? @amiya
  	assert_not @amiya.following? @randa

  	assert_not @amiya.following? @sirka
  	assert_not @sirka.following? @amiya
  end

  test "should have blocked users" do
    assert @sirka.blocking? @amiya
    assert @amiya.blocking? @sirka
    assert_not @sirka.blocking? @randa
  end

  test "should be following other users" do
  end

end
