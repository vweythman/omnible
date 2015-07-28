require 'test_helper'

class ViewableTest < ActiveSupport::TestCase

  setup do
    @amiya = users(:amiya)
    @randa = users(:randa)
    @sirka = users(:sirka)
    @indra = users(:indra)

    # Characters
    @mary = characters(:mary) # uploaded by randa ## PERSONAL with INVITES
    @jane = characters(:jane) # uploaded by sirka ## PUBLIC
    @erik = characters(:erik) # uploaded by amiya ## EXCEPT_BLOCKED

    # Works
    @flight = works(:flight) # uploaded by randa ## FRIENDS_ONLY
    @baffle = works(:baffle) # uploaded by sirka ## EXCEPT_BLOCKED
    @offend = works(:offend) # uploaded by amiya ## PUBLIC
  end

  test "should always allow creator to view" do
    assert @mary.viewable?(@randa)
    assert @jane.viewable?(@sirka)
    assert @erik.viewable?(@amiya)

    assert @flight.viewable?(@randa)
    assert @baffle.viewable?(@sirka)
    assert @offend.viewable?(@amiya)
  end

  test "should be private" do
  end

  test "should allow invited users to view" do
    assert @mary.viewable?(@sirka)
    assert_not @mary.viewable?(@amiya)
    assert_not @mary.viewable?(@indra)
    assert_not @mary.viewable?(nil)
  end

  test "should let friends view" do
    assert @flight.viewable?(@sirka)
    assert_not @flight.viewable?(@amiya)
    assert_not @flight.viewable?(@indra)
    assert_not @flight.viewable?(nil)
  end

  test "should let friends and followers view" do
  end

  test "should only allow login users to view" do
  end

  test "should keep blocked users from viewing and be mostly public" do
    assert_not @erik.viewable?(@sirka)
    assert @erik.viewable?(@randa)
    assert @erik.viewable?(nil)

    assert @baffle.viewable?(@randa)
    assert @baffle.viewable?(@indra)
    assert @baffle.viewable?(nil)
    assert_not @baffle.viewable?(@amiya)
  end

  test "should be public" do
    assert @jane.viewable?(nil)
    assert @jane.viewable?(@randa)
    assert @jane.viewable?(@amiya)

    assert @offend.viewable?(@randa)
    assert @offend.viewable?(@indra)
    assert @offend.viewable?(@sirka)
    assert @offend.viewable?(nil)
  end

  test "should only have viewable in list" do
    # for anons
    chars1 = Character.for_anons
    works1 = Work.for_anons

    assert chars1.include?(@erik)
    assert chars1.include?(@jane)
    assert_not chars1.include?(@mary)

    assert_not works1.include?(@flight)
    assert works1.include?(@baffle)
    assert works1.include?(@offend)

    # for users
    chars2 = Character.viewable_for @amiya
    works2 = Work.viewable_for @amiya

    assert chars2.include?(@erik)
    assert chars2.include?(@jane)
    assert_not chars2.include?(@mary)

    assert_not works2.include?(@flight)
    assert_not works2.include?(@baffle)
    assert works2.include?(@offend)
  end
end
