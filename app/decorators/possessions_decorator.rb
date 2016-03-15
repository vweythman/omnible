class PossessionsDecorator < Draper::CollectionDecorator

	# MODULES
	# ============================================================
	include NestedFields

	# PUBLIC METHODS
	# ============================================================
	# CHECK
	# ------------------------------------------------------------
	def can_list?
		object.length > 0
	end

	# GET
	# ------------------------------------------------------------
	def heading
		"Items"
	end

	def klass
		:possessions
	end

	def organize_characters
		@organize_characters ||= Possession.organize_characters(object)
	end

	def organized_items
		@organized_items ||= Possession.organize_items(object)
	end

	def partial
		"subjects/characters/fields/possession_fields"
	end

	def possible
		@possible ||= Item.all.includes(:generic)
	end

	# ACTION
	# ------------------------------------------------------------
	def items
		organized_items.each do |relator, group|
			group = ItemsDecorator.decorate(group)
			yield(relator, group)
		end
	end

	# RENDER
	# ------------------------------------------------------------
	def characters
		values = ""
		Possession.organize_characters(object).each do |relator, group|
			values = values + h.subgrouped_list(relator, CharactersDecorator.decorate(group))
		end
		values
	end

end
