class Works::CastingsController < WorksController

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def show
		work
	end

	# PRIVATE METHODS
	# ============================================================
	private

	# FIND
	# ------------------------------------------------------------
	# Work :: find by id
	def work
		super
		@cast = @work
	end

	# Works :: find all with filtering
	def works
		@works = Collectables::Works::CastingsDecorator.decorate(Work.by_type("Casting").with_filters(index_params, current_user))
	end

	# SET
	# ------------------------------------------------------------
	def created_work
		@work = @cast = Casting.new(work_params).decorate
	end

	def new_work
		@work = @cast = Casting.new.decorate
		@cast.roll_calls.build
	end

	# define strong parameters
	def work_params
		based_permitted = base_work_params(:casting)
		cast_permitted  = params.require(:casting).permit(roll_calls_attributes: [:id, :avatar, :title, :description])
		based_permitted.merge cast_permitted
	end

end
