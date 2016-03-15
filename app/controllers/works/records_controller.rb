class Works::RecordsController < WorksController

	# FILTERS
	# ============================================================
	before_action :admin_restriction, only: [:create, :new]

	# PRIVATE METHODS
	# ============================================================
	private

	# CLEAN
	# ------------------------------------------------------------
	def work_params
		params.require(:record).permit(:title, :summary, :placeables,
			creatorships: [:category, :name], appearables: [:subject],
			relateables:  [:subject]
		)
	end

	# FIND
	# ------------------------------------------------------------
	# Work :: find by id
	def work
		super
		@record = @work
	end

	# Works :: find all with filtering
	def works
		@works = WorksDecorator.decorate(Record.with_filters(index_params, current_user))
	end

	# SET
	# ------------------------------------------------------------
	def created_work
		@work = @record = Record.new(work_params).decorate
	end

	def new_work
		@work = @record = Record.new.decorate
	end

end
