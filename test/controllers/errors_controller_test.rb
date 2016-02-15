require 'test_helper'

class ErrorsControllerTest < ControllerTestCase

  test "should get 403 error page" do
    get :e403
    assert_response :success
  end

  test "should get 404 error page" do
    get :e404
    assert_response :success
  end

  test "should get 406 error page" do
    get :e406
    assert_response :success
  end

  test "should get 422 error page" do
    get :e422
    assert_response :success
  end

  test "should get 500 error page" do
    get :e500
    assert_response :success
  end

end
