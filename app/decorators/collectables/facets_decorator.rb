module Collectables
	class FacetsDecorator < Draper::CollectionDecorator

		# MODULES
		# ------------------------------------------------------------
		include ListableCollection
		include TableableCollection
		include Widgets::ListableResults

		# PUBLIC METHODS
		# ------------------------------------------------------------
		def creation_path
			if h.user_signed_in? && h.current_user.site_owner?
				h.inline_creation_toolkit "Identity Category (Facet)", :facet
			end
		end

		def inline_creation
			h.form_div_for_ajaxed_creation "facet"
		end

		def caption_heading
			index_heading
		end

		def index_heading
			"Identity Categories (Facets)"
		end

		def klass
			:facets
		end

		def admin_table
			h.render "categories/facets/facets_table"
		end

		# PRIVATE METHODS
		# ------------------------------------------------------------
		private

		def table_type
			:inlines
		end

	end
end
