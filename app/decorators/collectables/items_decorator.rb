module Collectables
	class ItemsDecorator < Draper::CollectionDecorator

		# MODULES
		# ------------------------------------------------------------
		include ListableCollection
		include PageCreating
		include Widgets::Definitions

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

		def organized
			keys = self.generics.pluck(:id, :name).to_h
			results = {}

			self.each do |item|
				key = keys[item.generic_id]
				if results[key].nil?
					results[key] = []
				end
				results[key] << item
			end

			results
		end

		# -- Lists
		# ............................................................
		def can_list?
			self.length > 0
		end

		# -- Related
		# ............................................................
		def generics
			@generics ||= Generic.all.order(:name)
		end

	end
end
