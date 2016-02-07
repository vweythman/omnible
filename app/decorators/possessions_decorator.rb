class PossessionsDecorator < Draper::CollectionDecorator

	# MODULES
	# ------------------------------------------------------------
	include NestedFields

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- About
	# ............................................................
	def can_list?
		object.length > 0
	end

	def heading
		"Items"
	end

	def klass
		:possessions
	end

	# -- Location
	# ............................................................
	def partial
		"subjects/characters/fields/possession_fields"
	end

	# -- Related
	# ............................................................
	def characters
		values = ""
		Possession.organize_characters(object).each do |relator, group|
			values = values + h.subgrouped_list(relator, CharactersDecorator.decorate(group))
		end
		values
	end

	def items 
		values = ""
		Possession.organize_items(object).each do |relator, group|
			values = values + h.subgrouped_list(relator, ItemsDecorator.decorate(group))
		end
		values
	end

	def possible
		@possible ||= Item.all.includes(:generic)
	end

end
