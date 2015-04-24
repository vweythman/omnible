require 'test_helper'

class IdentityTest < ActiveSupport::TestCase
  setup do
    @identity = identities(:young)
  end

  test "should have facet" do 
  	assert_not @identity.facet.nil?
  end

end
