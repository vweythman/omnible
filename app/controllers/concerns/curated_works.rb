# Curated Methods
# ================================================================================

module CuratedWorks

	def index
		@works = works
		@works.set_parent @parent.decorate
	end

	def works
		work_parent
		WorksCurationDecorator.decorate(@parent.works.with_filters(index_params, current_user))
	end

	def work_parent
		nil
	end

end