class Works::PoemsController < WorksController

	# PRIVATE METHODS
	# ============================================================
	private

	# CLEAN
	# ------------------------------------------------------------
	# WorkParams :: define strong parameters
	def work_params
		based_permitted = base_work_params(:poem)
		based_permitted.merge(:poem_content => params[:poem][:poem_content])
	end

	# FIND
	# ------------------------------------------------------------
	# Work :: find by id
	def work
		super
		@poem = @work
	end

	# Works :: find all with filtering
	def works
		@works = Collectables::PoemsDecorator.decorate(Work.by_type("Poem").with_filters(index_params, current_user))
	end

	# SET
	# ------------------------------------------------------------
	def created_work
		@work = @poem = Poem.new(work_params).decorate
	end

	def new_work
		@work = @poem = Poem.new.decorate
		@work.rating = Rating.new
	end

end
