class Works::NonfictionController < WorksController

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		find_works
		@works = NonfictionDecorator.decorate(@works)
		render 'works/index'
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# find all with options from a works_controller filter
	def find_works
		@works = Nonfiction.with_filters(index_params, current_user).decorate
	end

end
