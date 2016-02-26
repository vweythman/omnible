require 'test_helper'

class ContentHelperTest < ActionView::TestCase

  test "should use correct article" do
    mirror = indefinite_article "mirror is shiny"
    assert_not_equal "An mirror is shiny", mirror
    assert_equal "A mirror is shiny", mirror
    
    arch = indefinite_article "arch by itself"
    assert_not_equal "A arch by itself", arch
    assert_equal "An arch by itself", arch

    nasa = indefinite_article "NASA mission"
    assert_not_equal "An NASA mission", nasa
    assert_equal "A NASA mission", nasa

    fbi = indefinite_article "FBI agent"
    assert_not_equal "A FBI agent", fbi
    assert_equal "An FBI agent", fbi
  end

end
