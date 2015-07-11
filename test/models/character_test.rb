require 'test_helper'

class CharacterTest < ActiveSupport::TestCase

  setup do
    @mary = characters(:mary)
    @jane = characters(:jane)
    @erik = characters(:erik)
    @cinders = users(:cinders)
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

  test "should be cloneable" do
    assert_equal true, @mary.allow_clones
    assert @mary.cloneable?
  end

  test "should create a clone" do
    @mary2  = @mary.replicate(@cinders)
    @mary.reload
    assert @mary.has_clone? @mary2
    assert_equal @cinders, @mary2.uploader
  end

  test "should not create a clone" do
    assert_equal false, @erik.cloneable?
    @empty = @erik.replicate(@cinders)
    assert_equal nil, @empty
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
