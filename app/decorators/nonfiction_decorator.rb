class NonfictionDecorator < WorksDecorator

	def title
		"Nonfiction"
	end

	def local_types
		[:articles]
	end

	def external_types
		[]
	end
end
