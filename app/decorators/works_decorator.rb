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
		local_types.merge external_types
	end

	def storage_nav
		{all: :works, local: "local", offsite: "offsite"}
	end

	def local_types
		{
			:articles      => h.articles_path(clean_type_params),
			:stories       => h.stories_path(clean_type_params),
			:short_stories => h.short_stories_path(clean_type_params)
		}
	end

	def external_types
		{ :story_records => h.story_records_path(clean_type_params) }
	end

	def filter_values
		{
			:order => {
				title: "Sort Order",
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
					{ heading: "Today",   key: "today" },
					{ heading: "One Month", key: "thismonth" },
					{ heading: "One Year",  key: "thisyear" },
					{ heading: "All Time",     key: "all" }
				]
			},
			:completion => {
				title: "Completion",
				type: :completion,
				values: [
					{ heading: "Any",        key: "any" },
					{ heading: "Incomplete", key: "no" },
					{ heading: "Completed",  key: "yes" }
				]
			}
		}
	end

	def for_categories
		all_link    = h.content_tag :li do link_to_all end
		other_links = type_links

		h.content_tag :ul do 
			all_link + other_links
		end
	end

	def type_links
		links = self.types.map {|key, p| h.content_tag :li do h.link_to("#{key}".humanize.titleize, p) end }
		links.join.html_safe
	end

	def clean_type_params
		para = h.params.dup
		para.delete(:controller)
		para.delete(:action)
		para
	end

end
