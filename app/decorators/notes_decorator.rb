class NotesDecorator < Draper::CollectionDecorator

	def meta_title(work)
		work.title + " - Notes"
	end

end
