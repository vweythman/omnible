module Collectables
	module Works
		class NotesDecorator < Draper::CollectionDecorator

			# PUBLIC METHODS
			# ------------------------------------------------------------
			def meta_title(work)
				work.title + " - Notes"
			end

		end
	end
end

