module TagWithSimpleTags
	include TagWithUploadable

	def tag_batch(new_values, visitor)
		Tag.batch_by_name(new_values, visitor)
	end

end
