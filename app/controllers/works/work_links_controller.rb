class Works::WorkLinksController < WorksController

	# PRIVATE METHODS
	# ============================================================
	private

	# FIND
	# ------------------------------------------------------------
	# Work :: find by id
	def work
		super
		@link = @work
	end

	# Works :: find all with filtering
	def works
		@works = Collectables::WorkLinksDecorator.decorate(Work.by_type("WorkLink").with_filters(index_params, current_user))
	end

	# SET
	# ------------------------------------------------------------
	def created_work
		@work = @link = WorkLink.new(work_params).decorate
	end

	def new_work
		@work = @link = WorkLink.new.decorate
		link_sources
	end

	def link_sources
		@link.sources.build
	end

	# WorkParams :: define strong parameters
	def work_params
		based_permitted = base_work_params(:work_link)
		story_permitted = params.require(:work_link).permit(sources_attributes: [:id, :reference])
		based_permitted.merge story_permitted
	end

end
