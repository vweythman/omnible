module Collectables
	class FictionDecorator < Collectables::WorksDecorator

		# PUBLIC METHODS
		# ------------------------------------------------------------
		def title
			"Fiction"
		end

		def filter_values
			filters = super
			filters[:vrating] = {
				title: "Rated for Violence",
				type: :vrating,
				values: [
					{ heading: "Unfiltered", key: nil },
					{ heading: "Absent",   key: "0" },
					{ heading: "Minor",    key: "1" },
					{ heading: "Medium",   key: "2" },
					{ heading: "Major",    key: "3" },
					{ heading: "Explicit", key: "4" },
				]
			}
			filters[:srating] = {
				title: "Rated for Sexual Content",
				type: :srating,
				values: [
					{ heading: "Unfiltered", key: nil },
					{ heading: "Absent",   key: "0" },
					{ heading: "Minor",    key: "1" },
					{ heading: "Medium",   key: "2" },
					{ heading: "Major",    key: "3" },
					{ heading: "Explicit", key: "4" },
				]
			}
			filters[:prating] = {
				title: "Rated for Profanity",
				type: :prating,
				values: [
					{ heading: "Unfiltered", key: nil },
					{ heading: "Absent",   key: "0" },
					{ heading: "Minor",    key: "1" },
					{ heading: "Medium",   key: "2" },
					{ heading: "Major",    key: "3" },
					{ heading: "Explicit", key: "4" },
				]
			}
			return filters
		end

	end
end
