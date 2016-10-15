require 'test_helper'
module Works
  module Chapters
    class PrevControllerTest < ControllerTestCase

      setup do
        # Users
        @sirka = users(:sirka)

        # Stories
        @helix  = works(:helix)

        # Chapters
        @helix1  = chapters(:helix_one)
        @heart0  = chapters(:heart_zero)
      end

      test "should create chapter before old" do
        sign_in @sirka

        old_position = @helix1.position

        assert_difference('Chapter.count') do
          post :create, chapter_id: @helix1.id, chapter: { title: @helix1.title, content: @helix1.content }
        end

        assert_equal assigns(:chapter).position, old_position
        assert assigns(:story).chapters.include? assigns(:chapter)
      end

    end
  end
end
