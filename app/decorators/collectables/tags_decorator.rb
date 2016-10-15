module Collectables
	class TagsDecorator < Draper::CollectionDecorator

		# MODULES
		# ------------------------------------------------------------
		include ListableCollection
		include DisabledCreation
		include Widgets::ListableResults

		# PUBLIC METHODS
		# ------------------------------------------------------------
		def index_heading
			"General Tags"
		end

		def klass
			@klass ||= :tags
		end

	end
end