require 'test_helper'

module Works
  module Curation
    class CharacterWorksControllerTest < ControllerTestCase

      setup do
        @erik      = characters(:erik)
        @glamour   = works(:glamour)
        @rainfalls = works(:rainfalls)
      end

      test "should get index" do
        get :index, character_id: @erik.id

        assert_response :success

        assert_not_nil assigns(:parent)
        assert_not_nil assigns(:works)

        assert assigns(:works).include? @glamour
        assert_not assigns(:works).include? @rainfalls
      end

    end
  end
end