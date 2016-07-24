module Collectables
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
		include Widgets::SnippetResults

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
			#local_types.merge external_types
			local_types
		end

		def organized
			object.organize object
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
			showing_links ? "Works and Links" : "Works"
		end

		def showing_links
			@showing_links ||= h.params[:show_links] || false
		end

		def link_display_question
			unless showing_links
				link_to_links = h.link_to "Reveal Any Hidden Links", h.url_for(h.params.merge(show_links: true))
				h.content_tag :p, class: "display-question" do
					"#{link_to_links}".html_safe
				end
			end
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
			{ :story_links => h.story_links_path }
		end

		def filter_values
			{
				:content_type => {
					title: "Content Type",
					type: :content_type,
					values: [
						{ heading: "All",     key: "all"     },
						{ heading: "Text",    key: "text"    },
						{ heading: "Images",  key: "picture" },
						{ heading: "Audio",   key: "audio"   },
						{ heading: "Video",   key: "video"   },
					]
				},
				:order => {
					title: "Sort Order",
					type: :sort,
					values: [
						{ heading: "Updated",       key: "updated" },
						{ heading: "Chronological", key: "chronological" },
						{ heading: "Alphabetical",  key: "alphabetical" },
					]
				},
				:time => {
					title: "Time",
					type: :date,
					values: [
						{ heading: "All Time",  key: "all" },
						{ heading: "Today",     key: "today" },
						{ heading: "One Month", key: "thismonth" },
						{ heading: "One Year",  key: "thisyear" },
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
				:fiction       => h.fiction_index_path,
				:nonfiction    => h.nonfiction_index_path
			}
		end

		def local_types
			{
				:artwork       => h.artwork_path,
				:articles      => h.articles_path,
				:branching_stories => h.branching_stories_path,
				:music_videos  => h.music_videos_path,
				:stories       => h.stories_path,
				:short_stories => h.short_stories_path,
			}
		end

		def uploaded_types
			{
				:artwork      => h.artwork_path,
				:music_videos => h.music_videos_path
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

		# TABLE
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		def table_type
			:works
		end

	end
end
