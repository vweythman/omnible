class Works::FictionController < WorksController

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		find_works
		@works = FictionDecorator.decorate(@works)
		render 'works/index'
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# find all with options from a works_controller filter
	def find_works
		@works = Fiction.with_filters(index_params, current_user)
	end

end
