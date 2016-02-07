require 'test_helper'

class IdentityTest < ActiveSupport::TestCase
  setup do
    @identity = identities(:young)
    @age      = facets(:age)
    @names    = {"age"=>"young;young adult", "species"=>"human"}
  end

  test "should have facet" do 
    assert_not @identity.facet.nil?
  end

  test "should get grouped identities" do
    assert "young;young adult", @names[@age.name]
    list = Identity.faceted_find_by(@names)
    list.include? @identity
  end

  test "should batch by names and facet" do
    list  = Identity.faceted_line_batch(@age.id, "young;young adult")
    assert list.include? @identity
  end

end
