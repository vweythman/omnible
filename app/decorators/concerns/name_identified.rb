module NameIdentified

	def heading
		self.name
	end

	def editing_title
		heading + " (Unsaved Draft)"
	end

	def heading_id
		klass + "-" + object.id.to_s
	end

	def klass
		self.object.class.to_s.downcase
	end

end
