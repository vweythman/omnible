# ExternalStory
# ================================================================================
# type of narrative work
# see Work for table variables

class ExternalStory < Fiction
	has_many :sources, as: :referencer
end
