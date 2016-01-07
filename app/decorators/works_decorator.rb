class WorksDecorator < Draper::CollectionDecorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate :current_page, :total_pages, :limit_value, :entry_name, :total_count, :offset_value, :last_page?

	# MODULES
	# ------------------------------------------------------------
	include ChangeSortable
	include ListableCollection
	include PanelableCollection
	include TableableCollection
	include RecentWidget

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- About
	# ............................................................
	def heading
		title
	end

	def title
		"Works"
	end

	def klass
		:works
	end

	def caption_heading
		title
	end
	
	# -- Aside
	# ............................................................
	def for_categories
		all_link    = h.content_tag :li do link_to_all end
		other_links = type_links

		h.content_tag :ul do 
			all_link + other_links
		end
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

	# -- Links
	# ............................................................
	def link_to_all
		h.link_to "All", h.polymorphic_path(storage_nav[:all])
	end

	def type_links
		links = self.types.map {|key, p| h.content_tag :li do h.link_to("#{key}".humanize.titleize, p) end }
		links.join.html_safe
	end

	# -- Paths
	# ............................................................
	def clean_type_params
		para = h.params.dup
		para.delete(:controller)
		para.delete(:action)
		para
	end

	def creation_path
		h.multi_kit types.keys.map {|k| k.to_s.singularize }
	end

	def external_types
		{ :story_links => h.story_links_path(clean_type_params) }
	end

	def local_types
		{
			:articles      => h.articles_path(clean_type_params),
			:stories       => h.stories_path(clean_type_params),
			:short_stories => h.short_stories_path(clean_type_params)
		}
	end

	def types
		local_types.merge external_types
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private
	def listable
		sort_by_update
	end

	def storage_nav
		{ all: :works, local: "local", offsite: "offsite" }
	end

	# -- Partial Type
	# ............................................................
	def list_type
		:timed_snippets
	end

	def table_type
		:uploaded_entitled
	end

	def results_type
		:filtered_panel
	end

	def results_content_type
		:paged_cell
	end

end
