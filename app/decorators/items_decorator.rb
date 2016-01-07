class ItemsDecorator < Draper::CollectionDecorator

	# MODULES
	# ------------------------------------------------------------
	include ListableCollection
	include PageCreating

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- About
	# ............................................................
	def heading
		"Items"
	end

	def title
		heading
	end

	def klass
		:items
	end

	# -- Lists
	# ............................................................
	def can_list?
		self.length > 0
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private
	def list_type
		:definitions
	end

	def listable
		Item.organize(object)
	end

end
