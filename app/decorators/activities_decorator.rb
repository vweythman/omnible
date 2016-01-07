class ActivitiesDecorator <  Draper::CollectionDecorator

	# MODULES
	# ------------------------------------------------------------
	include ListableCollection
	include DisabledCreation

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def index_heading
		"Event Tags"
	end

	def klass
		:activities
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	def list_type
		:links
	end

	def results_content_type
		:titled_cell
	end

end
