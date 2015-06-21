module Organizable

	# Organize
	# - organizes models by their type
	def organize(models)
		list = Hash.new
		models.each do |model|
			list[model.type] = Array.new if list[model.type].nil?
			list[model.type].push(model)
		end
		return list.sort
	end

end
