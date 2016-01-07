module Titleizeable

	def heading
		@heading ||= find_title
	end

	def default_heading
		"Untitled"
	end

	def editing_title
		meta_title + " (Unsaved Draft)"
	end

	def meta_title
		find_title
	end
	
	private

	def find_title
		object.title.blank? ? default_heading : object.title
	end

end
