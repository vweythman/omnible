require 'test_helper'

class EditableTest < ActiveSupport::TestCase

  setup do
    @cinders = users(:cinders)
    @randa   = users(:randa)
    @sirka   = users(:sirka)

    # Characters
    @mary = characters(:mary) # by randa   ## PRIVATE WITH INVITES
    @jane = characters(:jane) # by sirka   ## PUBLIC
    @erik = characters(:erik) # by cinders ## PRIVATE
  end

  test "should always allow creator to edit" do
    assert @mary.editable?(@randa)
    assert @jane.editable?(@sirka)
    assert @erik.editable?(@cinders)
  end

  test "should be private" do
    assert_not @erik.editable?(@sirka)
    assert_not @erik.editable?(@randa)
    assert_not @erik.editable?(nil)
  end

  test "should allow invited users to edit" do
    assert @mary.editable?(@sirka)
    assert_not @mary.editable?(@cinders)
    assert_not @mary.editable?(nil)
  end

  test "should let friends edit" do
  end

  test "should let friends and followers edit" do
  end

  test "should only allow login users to edit" do
  end

  test "should keep blocked users from editing and be mostly public otherwise" do
  end

  test "should be public" do
    assert @jane.editable?(nil)
    assert @jane.editable?(@randa)
    assert @jane.editable?(@cinders)
  end

end
