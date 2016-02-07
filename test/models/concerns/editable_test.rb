require 'test_helper'

class EditableTest < ActiveSupport::TestCase

  setup do
    # Users
    @amiya = users(:amiya)
    @randa = users(:randa)
    @sirka = users(:sirka)
    @indra = users(:indra)
    @letty = users(:letty)

    # Characters
    @mary = characters(:mary) # uploaded by randa ## PERSONAL with INVITES
    @jane = characters(:jane) # uploaded by sirka ## PUBLIC
    @erik = characters(:erik) # uploaded by amiya ## PERSONAL

    # Articles
    @apologia = works(:apologia) # uploaded by sirka ## PERSONAL
    @theocrat = works(:theocrat) # uploaded by amiya ## PERSONAL
    @skywalks = works(:skywalks) # uploaded by indra ## FRIENDS_ONLY

    # Short Stories
    @calypso = works(:calypso) # uploaded by amiya ## FRIENDS_ONLY
    @effaces = works(:effaces) # uploaded by indra ## PERSONAL
    @glamour = works(:glamour) # uploaded by sirka ## FRIENDS_N_FOLLOWERS

    # Chaptered Stories
    @heart  = works(:heart)  # uploaded by indra ## EXCEPT_BLOCKED
    @helix  = works(:helix)  # uploaded by sirka ## FRIENDS_N_FOLLOWERS
    @frenzy = works(:frenzy) # uploaded by amiya ## PERSONAL

    # Story Links
    @zoologist = works(:zoologist) # uploaded by indra ## MEMBERS_ONLY
    @windstorm = works(:windstorm) # uploaded by sirka ## PERSONAL
    @viperfish = works(:viperfish) # uploaded by amiya ## MEMBERS_ONLY

  end

  test "should always allow creator to edit" do
    assert @mary.editable?(@randa)
    assert @jane.editable?(@sirka)
    assert @erik.editable?(@amiya)

    assert @apologia.editable?(@sirka)
    assert @theocrat.editable?(@amiya)
    assert @skywalks.editable?(@indra)

    assert @calypso.editable?(@amiya)
    assert @effaces.editable?(@indra)
    assert @glamour.editable?(@sirka)

    assert @heart.editable?(@indra)
    assert @helix.editable?(@sirka)
    assert @frenzy.editable?(@amiya)
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
    assert @calypso.editable?(@randa)
    assert_not @calypso.editable?(@sirka)
    assert_not @calypso.editable?(@indra)
    assert_not @calypso.editable?(nil)
  end

  test "should let friends and followers edit unless blocked" do
    assert @glamour.editable?(@randa)
    assert @glamour.editable?(@letty)
    assert_not @glamour.editable?(@amiya)
    assert_not @glamour.editable?(@indra)
    assert_not @glamour.editable?(nil)
  end

  test "should allow users to edit unless blocked" do
    assert @heart.editable?(@randa)
    assert @heart.editable?(@amiya)
    assert_not @heart.editable?(nil)
    assert_not @heart.editable?(@sirka)
  end

  test "should allow users to edit" do
    assert @zoologist.editable?(@randa)
    assert @zoologist.editable?(@amiya)
    assert @zoologist.editable?(@sirka)
    assert_not @zoologist.editable?(nil)
  end

  test "should be public" do
    assert @jane.editable?(nil)
    assert @jane.editable?(@randa)
    assert @jane.editable?(@amiya)
    assert @jane.editable?(@indra)
  end

end
