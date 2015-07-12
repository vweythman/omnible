require 'test_helper'

class ViewableTest < ActiveSupport::TestCase

  setup do
    @cinders = users(:cinders)
    @randa   = users(:randa)
    @sirka   = users(:sirka)

    # Characters
    @mary = characters(:mary) # by randa   ## PRIVATE WITH INVITES
    @jane = characters(:jane) # by sirka   ## PUBLIC
    @erik = characters(:erik) # by cinders ## EXCEPT_BLOCKED
  end

  test "should always allow creator to view" do
    assert @mary.viewable?(@randa)
    assert @jane.viewable?(@sirka)
    assert @erik.viewable?(@cinders)
  end

  test "should be private" do
  end

  test "should allow invited users to view" do
    assert @mary.viewable?(@sirka)
    assert_not @mary.viewable?(@cinders)
    assert_not @mary.viewable?(nil)
  end

  test "should let friends view" do
  end

  test "should let friends and followers view" do
  end

  test "should only allow login users to view" do
  end

  test "should keep blocked users from viewing and be mostly public" do
    assert_not @erik.viewable?(@sirka)
    assert @erik.viewable?(@randa)
    assert @erik.viewable?(nil)
  end

  test "should be public" do
    assert @jane.viewable?(nil)
    assert @jane.viewable?(@randa)
    assert @jane.viewable?(@cinders)
  end
end
