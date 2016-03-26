# Curated Methods
# ================================================================================

module CuratedWorks

	def index
		works
	end

	def works
		works_parent
		@works = WorksCurationDecorator.decorate(@parent.works.with_filters(index_params, current_user))
	end

	def work_parent
		nil
	end

end
