require 'test_helper'
module Subjects
  class ReplicateControllerTest < ControllerTestCase

      # SETUP
      # ============================================================
      setup do
        @mary = characters(:mary)
        @jane = characters(:jane)
        @erik = characters(:erik)

        @sirka = users(:sirka)
        @amiya = users(:amiya)
        @indra = users(:indra)

        @becca = users(:becca)
        @letty = users(:letty)
        @tegan = users(:tegan)
      end

      # TESTS
      # ============================================================
      test "should create clone" do
        sign_in @becca
        count = @mary.clones.size

        post :create, id: @mary.id

        assert_response :success
        assert_not_nil assigns(:original)
        assert_equal count + 1, assigns(:original).clones.size
      end

      test "should not create clone" do
        sign_in @becca

        post :create, id: @erik.id
        assert_redirected_to @erik
        assert_not_nil assigns(:original)
      end

      test "should create clone if user is uploader" do
        sign_in @amiya
        count = @erik.clones.size

        post :create, id: @erik.id

        assert_response :success
        assert_not_nil assigns(:original)
        assert_equal count + 1, assigns(:original).clones.size
      end

  end
end
