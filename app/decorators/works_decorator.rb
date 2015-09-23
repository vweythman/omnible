class WorksDecorator < Draper::CollectionDecorator
	delegate :current_page, :total_pages, :limit_value, :entry_name, :total_count, :offset_value, :last_page?

	def title
		"Works"
	end

	def heading
		title
	end

	def creation_path
		""
	end

	def link_to_all
		h.link_to "All", h.polymorphic_path(storage_nav[:all])
	end

	def types
		local_types + external_types
	end

	def storage_nav
		{all: :works, local: "local", offsite: "offsite"}
	end

	def local_types
		[:articles, :stories, :short_stories]
	end

	def external_types
		[:story_records]
	end

	def filter_values
		{
			:order => {
				title: "Order",
				type: :sort,
				values: [
					{ heading: "Alphabetical",  key: "alphabetical" },
					{ heading: "Chronological", key: "chronological" },
					{ heading: "Updated",       key: "updated" },
				]
			},
			:time => {
				title: "Time",
				type: :date,
				values: [
					{ heading: "Today",      key: "today" },
					{ heading: "This Month", key: "thismonth" },
					{ heading: "This Year",  key: "thisyear" },
					{ heading: "All",        key: "all" }
				]
			}
		}
	end

end
