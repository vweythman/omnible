require 'test_helper'
module Works
  module Chapters
    class FirstControllerTest < ControllerTestCase

      setup do
        # Users
        @sirka = users(:sirka)

        # Stories
        @helix  = works(:helix)

        # Chapters
        @helix1  = chapters(:helix_one)
        @helix2  = chapters(:helix_two)
        @heart0  = chapters(:heart_zero)
      end

      test "should create first chapter" do
        sign_in @sirka
        assert_difference('Chapter.count') do
          post :create, story_id: @helix.id, chapter: { title: @helix1.title, content: @helix1.content }
        end

        assert_equal assigns(:story).chapters.ordered.first, assigns(:chapter)
      end

    end
  end
end