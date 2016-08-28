class Works::Curation::IntratagsWorksController < WorksController

	# MODULES
	# ============================================================
	include CuratedWorks
	
	# PRIVATE METHODS
	# ============================================================
	private

	def works
		@found_works = @parent.tagging_works_by_type(tagging_type).with_filters(index_params, current_user).toggle_links(show_links)
	end

	def works_parent
		@parent = Work.find(params[:work_id])
	end

	def tagging_type
		params[:tagging_type]
	end

end
