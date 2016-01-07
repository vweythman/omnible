class PlacesDecorator < Draper::CollectionDecorator

	# MODULES
	# ------------------------------------------------------------
	include ListableCollection
	include PageCreating

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def heading
		"Places"
	end

	def title
		heading
	end

	def klass
		:places
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private
	def list_type
		:definitions
	end

	def listable
		Place.organize(object) 
	end

	def results_type
		:filtered_panel
	end

end
