require 'test_helper'

class EditableTest < ActiveSupport::TestCase

  setup do
    @amiya = users(:amiya)
    @randa = users(:randa)
    @sirka = users(:sirka)
    @indra = users(:indra)

    # Characters
    @mary = characters(:mary) # uploaded by randa ## PERSONAL with INVITES
    @jane = characters(:jane) # uploaded by sirka ## PUBLIC
    @erik = characters(:erik) # uploaded by amiya ## PERSONAL

    # Works
    @flight = works(:flight) # uploaded by randa ## FRIENDS_ONLY
    @baffle = works(:baffle) # uploaded by sirka ## EXCEPT_BLOCKED
    @offend = works(:offend) # uploaded by amiya ## MEMBERS_ONLY
  end

  test "should always allow creator to edit" do
    assert @mary.editable?(@randa)
    assert @jane.editable?(@sirka)
    assert @erik.editable?(@amiya)

    assert @flight.editable?(@randa)
    assert @baffle.editable?(@sirka)
    assert @offend.editable?(@amiya)
  end

  test "should be private" do
    assert_not @erik.editable?(@sirka)
    assert_not @erik.editable?(@randa)
    assert_not @erik.editable?(@indra)
    assert_not @erik.editable?(nil)
  end

  test "should allow invited users to edit" do
    assert @mary.editable?(@sirka)
    assert_not @mary.editable?(@amiya)
    assert_not @mary.editable?(@indra)
    assert_not @mary.editable?(nil)
  end

  test "should let friends edit" do
    assert @flight.editable?(@sirka)
    assert_not @flight.editable?(@amiya)
    assert_not @flight.editable?(@indra)
    assert_not @flight.editable?(nil)
  end

  test "should let friends and followers edit unless blocked" do
  end

  test "should only allow login users to edit unless blocked" do
    assert @offend.editable?(@randa)
    assert @offend.editable?(@indra)
    assert_not @offend.editable?(@sirka)
    assert_not @offend.editable?(nil)
  end

  test "should keep blocked users from editing and be mostly public otherwise" do
    assert @baffle.editable?(@randa)
    assert @baffle.editable?(@indra)
    assert @baffle.editable?(nil)
    assert_not @baffle.editable?(@amiya)
  end

  test "should be public" do
    assert @jane.editable?(nil)
    assert @jane.editable?(@randa)
    assert @jane.editable?(@amiya)
    assert @jane.editable?(@indra)
  end

end
