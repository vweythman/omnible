# Curated Methods
# ================================================================================

module CuratedWorks

	def index
		works_parent
		works
		curation_decoration
	end

	def works
		@found_works = @parent.works.toggle_links(show_links).with_filters(index_params, current_user)
	end

	def curation_decoration
		@works = Collectables::Curations::WorksDecorator.decorate(@found_works)
	end

	def work_parent
		nil
	end

end
