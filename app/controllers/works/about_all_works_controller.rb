class Works::AboutAllWorksController < ApplicationController

	# PUBLIC METHODS
	# ============================================================
	def show
		ptable
		unless has_acceptable_table?
			redirect_to root_url
		else
			find_works
			all_counts
			tag_counts
		end
	end

	def activity
		ptable
		unless has_acceptable_table?
			redirect_to root_url
		else
			find_works
			all_counts
		end
	end

	def related
		ptable
		unless has_acceptable_table?
			redirect_to root_url
		else
			find_works
			tag_counts
		end
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def find_works
		class_name = params[:tagger_table]

		if class_name == 'tags'
			@parent = class_name.classify.constantize.friendly.find(params[:id])
		else
			@parent = class_name.classify.constantize.find(params[:id])
		end
	end

	def has_acceptable_table?
		['characters', 'users', 'tags', 'works', 'identities'].include? @ptable
	end

	def ptable
		@ptable = params[:tagger_table]
	end

	def all_counts
		@type_count          = @parent.tagging_works.onsite.count_by_type
		@content_type_count  = @parent.tagging_works.onsite.count_by_content_type

		@overtime_type_count = @parent.tagging_works.onsite.type_count_by_creation
		@updating_type_count = @parent.tagging_works.onsite.type_count_by_updated
	end

	def tag_counts
		@intrawork_count  = @parent.intraworks.onsite_ordered_title_count
		@identities_count = @parent.intrawork_identities.onsite_ordered_name_count
		@characters_count = @parent.intrawork_characters.onsite_ordered_name_count
		@tags_count       = @parent.intrawork_tags.onsite_ordered_name_count
		@places_count     = @parent.intrawork_places.onsite_count_by_name
		@squads_count     = @parent.intrawork_groups.onsite_ordered_name_count
	end

end