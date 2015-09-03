# ExternalComicSeries
# ================================================================================
# type of narrative work
# see Work for table variables

class ExternalComicSeries < Fiction
	has_many :sources, as: :referencer
end
