# StoryRecord
# ================================================================================
# type of narrative work
# see Work for table variables

class StoryRecord < Fiction
	has_many :sources, as: :referencer
end
