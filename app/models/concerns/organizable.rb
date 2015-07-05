module Organizable

	# Organize
	# - organizes models by their type
	def organize(models)
		if models.nil?
			return {}
		end

		list = Hash.new
		models.map { |model|
			unless model.nil?
				list[model.nature] = Array.new if list[model.nature].nil?
				list[model.nature] << model.linkable
			end
		}
		return list
	end

end
