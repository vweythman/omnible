require 'test_helper'

class CharacterTest < ActiveSupport::TestCase
  
  setup do
    @mary = characters(:mary)
    @jane = characters(:jane)
    @erik = characters(:erik)
  end

  test "should have heading the same as name" do
    assert_equal @mary.name, @mary.heading
    assert_equal @erik.name, @erik.heading
    assert_not_equal @mary.heading, @erik.heading
  end

  test "should be subject" do
    assert @jane.is_subject?
    assert @erik.is_subject?
  end

  test "should create a clone" do
    cinders = users(:cinders)
    mary2   = @mary.replicate(cinders)
    assert_not_equal @mary, mary2
    assert_not_equal @mary.is_a_clone?
    assert_equal mary2.is_a_clone?
  end

  test "should get next" do
    assert_equal @jane, @erik.next_character
    assert_equal @mary, @jane.next_character
    assert_not_equal @erik, @mary.next_character
  end

  test "should get prev" do
    assert_equal @erik, @jane.prev_character
    assert_equal @jane, @mary.prev_character
    assert_not_equal @mary, @erik.prev_character
  end

end
