module TagWithUploadable

	def sort_values(all_values)
		current_values   = proxy_association.association_scope.map(&:tag_heading)
		clean_values     = all_values.split(";").map {|n| n.strip }
		unchanged_values = current_values & clean_values
		new_values       = (clean_values - current_values).join(";")
		unchanged_tags   = proxy_association.association_scope.select{|x| unchanged_values.include? x.tag_heading }
		[unchanged_tags, new_values]
	end

	def batch_current(all_values, visitor) 
		unchanged_tags, new_values = sort_values(all_values)
		new_tags                   = tag_batch(new_values, visitor)
		current_tags               = unchanged_tags + new_tags
	end

end
