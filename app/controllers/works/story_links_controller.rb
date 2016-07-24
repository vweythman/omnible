class Works::StoryLinksController < WorksController

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
		@works = Collectables::StoryLinksDecorator.decorate(Work.by_type("StoryLink").with_filters(index_params, current_user))
	end

	# SET
	# ------------------------------------------------------------
	def created_work
		@work = @link = StoryLink.new(work_params).decorate
	end

	def new_work
		@work = @link = StoryLink.new.decorate
		link_sources
	end

	def link_sources
		@link.sources.build
	end

	# WorkParams :: define strong parameters
	def work_params
		based_permitted = base_work_params(:story_link)
		story_permitted = params.require(:story_link).permit(sources_attributes: [:id, :reference])
		based_permitted.merge story_permitted
	end

end
