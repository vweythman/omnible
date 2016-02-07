require 'test_helper'
module Subjects
  class ClonesControllerTest < ControllerTestCase

      # SETUP
      # ============================================================
      setup do
        @jane           = characters(:jane)          # can clone but not allow as clone
        @erik           = characters(:erik)          # cannot clone but can allow as clone
        @mayra_pen      = characters(:mayra_pen)     # cannot clone nor allow as clone
        @roleplay_john  = characters(:roleplay_john) # clone of jane
        @roleplay_jane  = characters(:roleplay_jane) # clone of jane
        @roleplay_allen = characters(:roleplay_allen)

        @sirka = users(:sirka)
        @becca = users(:becca)
      end

      # TESTS
      # ============================================================
      # GET NEW
      # ------------------------------------------------------------
      test "should get new" do
        sign_in @becca
        get :new, id: @erik.id
        assert_response :success
      end

      test "should not get new" do
        sign_in @becca
        get :new, id: @jane.id
        assert_redirected_to @jane
      end

      # CREATE
      # ------------------------------------------------------------
      test "should create" do
        sign_in @becca

        get :create, id: @erik.id, replication: { clone_id: @erik.id, original_id: @jane.id }

        assert_redirected_to @erik
        assert_equal assigns(:original), assigns(:clone).original
      end

      test "should not create when original not cloneable" do
        sign_in @becca

        post :create, id: @jane.id, replication: { clone_id: @jane.id, original_id: @mayra_pen.id }

        assert_redirected_to @jane
        assert_not_equal assigns(:original), assigns(:clone).original
      end

      test "should not create when character cannot be set as clone" do
        sign_in @becca

        post :create, id: @erik.id, replication: { clone_id: @jane.id, original_id: @roleplay_allen.id }

        assert_redirected_to @jane
        assert_not_equal assigns(:original), assigns(:clone).original
      end

      test "should not create when connection cannot be mutually made" do
        sign_in @becca

        post :create, id: @jane.id, replication: { clone_id: @jane.id, original_id: @erik.id }

        assert_redirected_to @jane
        assert_not_equal assigns(:original), assigns(:clone).original
      end

      # DELETE
      # ------------------------------------------------------------
      test "should remove original" do
        sign_in @sirka

        delete :destroy, id: @roleplay_john

        assert_redirected_to @roleplay_john
        assert_not assigns(:clone).is_a_clone?
      end

      test "should not remove original" do
        sign_in @becca

        delete :destroy, id: @roleplay_john

        assert_redirected_to @roleplay_john
        assert assigns(:clone).is_a_clone?
      end

  end
end
