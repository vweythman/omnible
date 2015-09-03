# ExternaComic
# ================================================================================
# type of narrative work
# see Work for table variables

class ExternalComic < Fiction
	has_many :sources, as: :referencer
end
