require 'test_helper'

class CharacterTest < ActiveSupport::TestCase

  setup do
    @mary = characters(:mary)
    @jane = characters(:jane)
    @erik = characters(:erik)
    @randa   = users(:randa)
    @sirka   = users(:sirka)
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

  test "should have creator" do
    assert @mary.creator? @randa
    assert @jane.creator? @sirka
    assert @erik.creator? @cinders
  end

  test "should be cloneable" do
    assert_equal true, @mary.allow_clones
    assert @mary.cloneable?
  end

  test "should create a clone" do
    @mary2 = @mary.replicate(@cinders)

    assert_not_equal nil, @mary2
    
    assert_equal @cinders, @mary2.uploader
    assert_equal @mary, @mary2.original
    assert @mary2.save

    @mary.reload
    assert @mary.has_clone? @mary2
  end

  test "should not create a clone" do
    assert_not @erik.cloneable?
    assert_equal nil, @erik.replicate(@cinders)
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

  test "should count reputations" do
    assert_equal 2, @mary.reputation_count
    assert_equal 2, @jane.reputation_count
    assert_equal 0, @erik.reputation_count
  end

  test "should average likableness" do
    likable = (Judgemental::LOWEST + Judgemental::HIGHEST) / 2
    assert_equal likable, @mary.likableness
  end

  test "should average respect" do
    respect = (Judgemental::NEUTRAL + Judgemental::HIGH) / 2
    assert_equal respect, @mary.respectedness
  end


end
