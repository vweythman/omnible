# StoryLink
# ================================================================================
# type of narrative work
# see Work for table variables

class StoryLink < Work
	has_many :sources, as: :referencer
end
