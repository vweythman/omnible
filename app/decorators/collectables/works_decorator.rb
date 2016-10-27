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
			@klass ||= :works
		end

		def title
			showing_links ? "Works and Links" : "Works"
		end

		def showing_links
			@showing_links ||= h.params[:show_links] || false
		end

		def link_display_question
			unless showing_links
				link_to_links = h.link_to h.t('question.link_reveal'), h.url_for(h.params.merge(show_links: true))
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
			{ :work_links => h.work_links_path }
		end

		def filter_values
			{
				:content_type => {
					title: "Content Type",
					type: :content_type,
					values: [
						{ heading: h.t('content.all'),     key: "all"     },
						{ heading: h.t('content.text'),    key: "text"    },
						{ heading: h.t('content.images'),  key: "picture" },
						{ heading: h.t('content.audio'),   key: "audio"   },
						{ heading: h.t('content.video'),   key: "video"   },
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

		def filter_labels
			@filter_labels ||= sort_filter_labels
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
				:journals      => h.journals_path,
				:music_videos  => h.music_videos_path,
				:comics        => h.comics_path,
				:poems         => h.poems_path,
				:branching_stories => h.branching_stories_path,
				:stories       => h.stories_path,
				:short_stories => h.short_stories_path
			}
		end

		def unset_types
			{
				:webisodes     => nil,
				:podcasts      => nil,
				:radio_plays   => nil,
				:songs         => nil
			}
		end

		def uploaded_types
			{
				:artwork      => h.artwork_path,
				:music_videos => h.music_videos_path
			}
		end

		# TOOLKIT
		# ------------------------------------------------------------
		def directory_sections
			any_type = (self.types.merge self.unset_types)
			any_type.map {|key, p| [h.t("content_types.#{key}"), p] }
		end

		def directory
			h.directory_kit directory_sections
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

		def sort_filter_labels
			filter_labels = {}
			label_groups  = {
				tags: Tagging.work_filter_labels,
				characters: Appearance.filter_labels,
				squads: SocialAppearance.filter_labels,
				works: WorkConnection.filter_labels
			}
			label_groups.each do |type, filters|
				filters.each do |group, label|
					filter_labels[label] = [type, group]
				end
			end
			filter_labels["Places"] = [:places]

			filter_labels.sort
		end

	end
end
