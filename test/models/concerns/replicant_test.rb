require 'test_helper'

class ReplicantTest < ActiveSupport::TestCase
  setup do
    @mary = characters(:mary)
    @jane = characters(:jane)
    @erik = characters(:erik)

    @randa = users(:randa)
    @sirka = users(:sirka)
    @amiya = users(:amiya)

    @roleplay_jane = characters(:roleplay_jane)
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
    assert_equal nil, @erik.replicate(@amiya)
  end

  # QUESTIONS
  # ------------------------------------------------------------
  test "should be able to set as clone" do
  end

  test "should have clones" do

  end

  test "should be cloneable" do
    assert @mary.cloneable?
  end

  test "should not be cloneable" do
    assert_not @erik.cloneable?
  end

  test "should be a clone" do
  end

end