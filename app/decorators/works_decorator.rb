class WorksDecorator < Draper::CollectionDecorator

	# DELEGATION
	# ============================================================
	delegate :current_page, :total_pages, :limit_value, :entry_name, :total_count, :offset_value, :last_page?

	# MODULES
	# ============================================================
	include ListableCollection
	include PanelableCollection
	include TableableCollection
	include Widgets::Recent

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def caption_heading
		title
	end

	def creation_path
		h.multi_kit types.keys.map {|k| k.to_s.singularize }
	end

	def found_count
		self.total_count
	end

	def types
		local_types.merge external_types
	end

	# SET
	# ------------------------------------------------------------
	# IDENTIFER
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def heading
		title
	end

	def klass
		:works
	end

	def title
		"Works"
	end

	# SORT
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def clean_type_params
		para = h.params.dup
		para.delete(:controller)
		para.delete(:action)
		para
	end

	def external_types
		{ :story_links => h.story_links_path(clean_type_params) }
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

	def category_types
		{
			:fiction       => h.fiction_index_path(clean_type_params),
			:nonfiction    => h.nonfiction_index_path(clean_type_params)
		}
	end

	def local_types
		{
			:articles      => h.articles_path(clean_type_params),
			:stories       => h.stories_path(clean_type_params),
			:branching_stories => h.branching_stories_path(clean_type_params),
			:short_stories => h.short_stories_path(clean_type_params),
		}
	end

	# RENDER
	# ------------------------------------------------------------
	def for_categories
		all_link    = h.content_tag :li do link_to_all end
		other_links = type_links

		h.content_tag :ul, class: "type-categories" do 
			all_link + other_links
		end
	end

	def link_to_all
		h.link_to "All Works", h.polymorphic_path(:works)
	end

	def type_links
		(self.category_types.merge self.types).map {|key, p|
			h.content_tag :li do h.link_to("#{key}".humanize.titleize, p) end 
		}.join.html_safe
	end

	# PRIVATE METHODS
	# ============================================================
	private

	# ACT
	# ------------------------------------------------------------
	def sort_by_update
		w = Hash.new
		dates.map { |t| 
			w[t] = self.select{|x| h.record_time(x.updated_at) == t}
		}

		return w
	end

	def dates
		self.map { |x| h.record_time x.updated_at }.uniq
	end

	# SET
	# ------------------------------------------------------------
	# LIST
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def listable
		sort_by_update
	end

	def list_type
		:timed_snippets
	end

	# RESULTS
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def results_type
		:filtered_panel
	end

	def results_content_type
		:paged_cell
	end

	# TABLE
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def table_type
		:works
	end

end