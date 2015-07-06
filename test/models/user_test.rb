require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @cinders = users(:cinders)
    @randa   = users(:randa)
    @sirka   = users(:sirka)
  end

  test "should create friendships" do
  	assert @randa.friend? @sirka
  	assert @sirka.friend? @randa
  	assert @cinders.friend? @randa
  end

  test "should have mutual friends" do
  	assert @randa.mutual_friend? @sirka
  	assert_not @sirka.mutual_friend? @cinders
  end

  test "should have followers" do
  	assert @sirka.following? @randa
  	assert @sirka.following? @cinders
  	assert @randa.following? @cinders
  	assert_not @cinders.following? @randa
  	assert_not @cinders.following? @sirka
  	assert_not @randa.following? @sirka
  end

  test "should be following other users" do
  end

end
