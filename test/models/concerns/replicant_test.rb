require 'test_helper'

class ReplicantTest < ActiveSupport::TestCase
  setup do
    @mary = characters(:mary)
    @jane = characters(:jane)
    @erik = characters(:erik)
    @mayra_pen     = characters(:mayra_pen)
    @roleplay_john = characters(:roleplay_john)
    @roleplay_jane = characters(:roleplay_jane)

    @randa = users(:randa)
    @sirka = users(:sirka)
    @amiya = users(:amiya)
    @becca = users(:becca)
  end

  # PUBLIC METHODS TESTS
  # ============================================================
  # ACTIONS
  # ------------------------------------------------------------
  test "should create a clone" do
    @mary2 = @mary.replicate(@amiya)

    assert_not_equal nil, @mary2
    
    assert_equal @amiya, @mary2.uploader
    assert_equal @mary, @mary2.original
    assert @mary2.save

    @mary.reload
    assert @mary.has_clone? @mary2
  end
  
  test "should not create a clone" do
    assert_equal nil, @erik.replicate(@becca)
  end

  test "should create connection" do
    @mary.connect_clone(@erik)
    assert @mary, @erik.original
  end

  test "should remove original" do
    assert_equal nil, @roleplay_jane.declone
    assert_not @roleplay_jane.is_a_clone?
  end

  # QUESTIONS
  # ------------------------------------------------------------
  # ABILITY
  # ............................................................
  test "should be able to set as clone" do
    assert @erik.can_be_a_clone? @becca
    assert @roleplay_jane.can_be_a_clone? @becca
  end

  test "should not be able to set as clone" do
    assert_not @jane.can_be_a_clone? @becca
    assert_not @mary.can_be_a_clone? @becca
    assert_not @roleplay_john.can_be_a_clone? @becca
    assert_not @mayra_pen.can_be_a_clone? @becca
  end

  test "should be cloneable" do
    assert @mary.cloneable? @becca
    assert @jane.cloneable? @becca
    assert @roleplay_john.cloneable? @becca
  end

  test "should not be cloneable" do
    assert_not @erik.cloneable? @becca
    assert_not @roleplay_jane.cloneable? @becca
    assert_not @mayra_pen.cloneable? @becca
  end

  # QUALITY
  # ............................................................
  test "should have clones" do
    assert @jane.has_clones?
  end

  test "should not have clones" do
    assert_not @erik.has_clones?
  end

  test "should be a clone" do
    assert @roleplay_jane.is_a_clone?
  end

end