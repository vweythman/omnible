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

    # Articles
    @apologia = works(:apologia) # uploaded by sirka ## FRIENDS_ONLY
    @theocrat = works(:theocrat) # uploaded by amiya ## EXCEPT_BLOCKED
    @skywalks = works(:skywalks) # uploaded by indra ## FRIENDS_ONLY

    # Short Stories
    @calypso = works(:calypso) # uploaded by amiya ## MEMBERS_ONLY
    @effaces = works(:effaces) # uploaded by indra ## PUBLIC
    @glamour = works(:glamour) # uploaded by sirka ## PUBLIC

    # Chaptered Stories
    @heart  = works(:heart)  # uploaded by indra ## EXCEPT_BLOCKED
    @helix  = works(:helix)  # uploaded by sirka ## MEMBERS_ONLY
    @frenzy = works(:frenzy) # uploaded by amiya ## PERSONAL

    # Story Links
    @zoologist = works(:zoologist) # uploaded by indra ## PUBLIC
    @windstorm = works(:windstorm) # uploaded by sirka ## FRIENDS_N_FOLLOWERS
    @viperfish = works(:viperfish) # uploaded by amiya ## MEMBERS_ONLY
  end

  test "should always allow creator to view" do
    assert @mary.viewable?(@randa)
    assert @jane.viewable?(@sirka)
    assert @erik.viewable?(@amiya)
  end

  test "should be private" do
    assert @frenzy.viewable?(@amiya)
    assert_not @frenzy.viewable?(@sirka)
    assert_not @frenzy.viewable?(@indra)
    assert_not @frenzy.viewable?(nil)
  end

  test "should allow invited users to view" do
    assert @mary.viewable?(@sirka)
    assert_not @mary.viewable?(@amiya)
    assert_not @mary.viewable?(@indra)
    assert_not @mary.viewable?(nil)
  end

  test "should let friends view" do
    assert @apologia.viewable?(@randa)
    assert_not @apologia.viewable?(@amiya)
    assert_not @apologia.viewable?(@indra)
    assert_not @apologia.viewable?(nil)
  end

  test "should let friends and followers view" do
    assert @windstorm.viewable?(@sirka)
    assert_not @windstorm.viewable?(@amiya)
    assert_not @windstorm.viewable?(@indra)
    assert_not @windstorm.viewable?(nil)
  end

  test "should only allow unblocked users to view" do
    assert @erik.viewable?(@randa)
    assert @erik.viewable?(@indra)
    assert_not @erik.viewable?(@sirka)
    assert_not @erik.viewable?(nil)
  end

  test "should only allow users to view" do
    assert @viperfish.viewable?(@randa)
    assert @viperfish.viewable?(@indra)
    assert @viperfish.viewable?(@sirka)
    assert_not @viperfish.viewable?(nil)
  end

  test "should be public" do
    assert @jane.viewable?(nil)
    assert @jane.viewable?(@randa)
    assert @jane.viewable?(@amiya)
  end

  test "should only have viewable in list" do
    # for anons
    chars1 = Character.for_anons
    works1 = Work.for_anons

    assert chars1.include?(@jane)
    assert_not chars1.include?(@erik)
    assert_not chars1.include?(@mary)

    assert works1.include?(@effaces)
    assert works1.include?(@zoologist)
    assert_not works1.include?(@heart)
    assert_not works1.include?(@viperfish)

    # for users
    chars2 = Character.viewable_for @amiya
    works2 = Work.viewable_for      @amiya

    assert chars2.include?(@erik)
    assert chars2.include?(@jane)
    assert_not chars2.include?(@mary)

    assert works2.include?(@glamour)
    assert works2.include?(@frenzy)
    assert works2.include?(@zoologist)
  end
end
