class Works::Curation::Intratags::SubjectController < WorksController

	# PUBLIC METHODS
	# ============================================================
	def index
		works
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def works
		works_parent
		@works = WorksCurationDecorator.decorate(@parent.reference_for.with_filters(index_params, current_user))
	end

	def works_parent
		@parent = Work.find(params[:work_id])
	end

end
