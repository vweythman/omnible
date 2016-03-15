require 'test_helper'

class CharacterTest < ActiveSupport::TestCase

  setup do
    @roleplay_allen = characters(:roleplay_allen) # PUBLIC - amiya
    @erik = characters(:erik) # EXCEPT_BLOCKED             - amiya
    @jane = characters(:jane) # PUBLIC                     - sirka
    @roleplay_john  = characters(:roleplay_john) # PUBLIC  - sirka
    @mary = characters(:mary) # PERSONAL                   - randa
    @roleplay_jane  = characters(:roleplay_jane) # PUBLIC  - sirka

    @sirka = users(:sirka)
    @amiya = users(:amiya)
  end

  # CLASS METHODS TESTS
  # ============================================================
  test "should create/find characters by name" do
    @names      = "Lily;Ethan"
    @list       = @names.split(";")
    @characters = Character.batch_by_name(@names, @sirka)
    @all_names  = @characters.map(&:name)
    assert @all_names.include?("Lily"), @all_names
  end

  test "should create/find nonfictional characters by name" do

  end

  test "should create nonfictional character" do
    character = Character.create_person("Martha", @erik.uploader)
    assert_not character.fictitious_person?
  end

  # PUBLIC METHODS TESTS
  # ============================================================
  # GETTERS
  # ------------------------------------------------------------

  # SETTERS
  # ------------------------------------------------------------
  test "should get next" do
    assert_equal @erik, @roleplay_allen.next_character(@amiya)
  end

  test "should skip blocked next" do
    assert_equal @jane, @roleplay_allen.next_character(@sirka)
  end

  test "should get prev" do
    assert_equal @jane, @roleplay_john.prev_character(@sirka)
  end

  test "should skip private prev" do
    assert_equal @roleplay_john, @roleplay_jane.prev_character(@amiya)
  end

  # CALCULATIONS
  # ------------------------------------------------------------
  test "should count reputations" do
    assert_equal 2, @mary.reputation_count
    assert_equal 2, @jane.reputation_count
    assert_equal 0, @erik.reputation_count
  end

  test "should average likableness" do
    likeable = ((Judgemental::LOWEST + Judgemental::HIGHEST) / 2).round
    assert_equal likeable, @mary.avgerage_likes
  end

  test "should average respect" do
    respect = ((Judgemental::NEUTRAL + Judgemental::HIGH) / 2).round
    assert_equal respect, @mary.avgerage_respect
  end

end
