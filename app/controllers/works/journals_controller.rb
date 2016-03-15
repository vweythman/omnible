class Works::JournalsController < WorksController

	# PRIVATE METHODS
	# ============================================================
	private

	# FIND
	# ------------------------------------------------------------
	def work
		super
		@journal = @work
	end

	# Works :: find all with filtering
	def works
		@works = JournalsDecorator.decorate(Journal.with_filters(index_params, current_user))
	end

	# SET
	# ------------------------------------------------------------
	def created_work
		@work = @journal = Journal.new(work_params).decorate
	end

	def new_work
		@journal = Journal.new
		@journal = @work = @journal.decorate
	end

	# WorkParams :: define strong parameters
	def work_params
		params.require(:journal).permit(
			:title,        :summary,    :taggables,
			:editor_level, :placeables, :publicity_level,

			appearables:         [:subject],
			relateables:         [:subject],
			uploadership:        [:category, :pen_name],
			skinning_attributes: [:id,       :skin_id, :_destroy]
		)
	end

end
