require 'test_helper'

class WorkConnectionTest < ActiveSupport::TestCase

  # SETUP
  # ============================================================
  setup do
  	# TAGGING
    @glamour = works(:glamour)

    # TAGGED & TAGGING
    @windstorm = works(:windstorm)

    # TAGGED
    @calypso   = works(:calypso)
  end

  # TESTS :: PUBLIC METHODS
  # ============================================================
  test "should create correct metadata key" do
    taggings        = WorkConnection.new
    taggings.nature = "cast"

    assert_equal "cast-taggings-count", taggings.metadata_key
    assert_equal "taggings-count", taggings.base_metadata_key
  end

  test "should increment metadata upon create" do
    assert_equal @windstorm.cast_from_works.count, 0

    @windstorm.cast_from_works << @glamour
    @windstorm.save

    assert_equal @windstorm.cast_from_works.count, 1
    assert_equal @glamour.cast_for.count, 1
    assert_equal @glamour.searchable_quantitative_metadata["cast-taggings-count"], 1
  end

  test "should decrement metadata upon destroy" do
    assert_equal @windstorm.general_in.count, 1

    @calypso.general_works.destroy [@windstorm]
    @calypso.save

    assert_equal @calypso.general_works.count, 0
    assert_equal 0, @windstorm.searchable_quantitative_metadata["general-taggings-count"]
  end

end
