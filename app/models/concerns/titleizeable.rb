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
		self.title.blank? ? self.default_heading : self.title
	end

end
