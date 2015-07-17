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
    # show
    assert_not @erik.viewable?(@sirka)
    assert @erik.viewable?(@randa)
    assert @erik.viewable?(nil)

    # index
    chars1 = Character.for_anons
    chars2 = Character.unblocked_for @randa
    chars3 = Character.unblocked_for @sirka

    assert chars1.include? @erik
    assert chars2.include?(@erik), "#{chars2.inspect} + #{@randa.blockers.inspect}"
    assert_not chars3.include? @erik
  end

  test "should be public" do
    # show
    assert @jane.viewable?(nil)
    assert @jane.viewable?(@randa)
    assert @jane.viewable?(@cinders)

    # index
    charlist = Character.for_anons
    assert charlist.include? @jane
  end
end
