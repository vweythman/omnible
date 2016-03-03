class StoryRoot < ActiveRecord::Base
	belongs_to :story, class_name: "Work"
	belongs_to :trunk, class_name: "Branch"
end
