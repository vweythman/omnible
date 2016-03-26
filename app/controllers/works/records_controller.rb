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
		based_permitted  = base_work_params(:record)
		record_permitted = params.require(:record).permit(medium_datum_attributes: [:id, :value])
		based_permitted.merge record_permitted
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
		@works = WorksDecorator.decorate(Record.with_filters(index_params, current_user).includes(:metadata))
	end

	# SET
	# ------------------------------------------------------------
	def created_work
		@work = @record = Record.new(work_params).decorate
	end

	def new_work
		@work = @record    = Record.new.decorate
		@work.medium_datum = RecordMetadatum.new
	end

	def set_editables
		super

		if @work.medium_datum.nil?
			@work.medium_datum = RecordMetadatum.new
		end
	end

end
