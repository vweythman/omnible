require 'active_support/concern'

module AsNameableTag
	extend ActiveSupport::Concern

	# CLASS METHODS
	# ============================================================
	class_methods do

		def tag_creation(name, uploader = nil)
			model = self.where(name: name).first
			model = self.create(name: name, uploader_id: uploader.id) if model.nil?
			model
		end

		def batch_by_name(names, uploader)
			self.transaction do 
				names.split(";").map { |name| 
					name.strip!
					tag_creation(name, uploader)
				}
			end
		end

		def merged_tag_names(old_tags, new_names, visitor)
			unchanged_tags, new_names_list = updated_tag_values(old_tags, new_names)
			(unchanged_tags + batch_by_name(new_names_list, visitor))
		end

		def updated_tag_values(current_tags, new_values)
			current_names = current_tags.map(&:tag_heading)
			clean_names   = new_values.split(";").map {|n| n.strip }

			unchanged_names = current_names & clean_names
			new_names_list  = (clean_names - current_names).join(";")

			unchanged_tags  = current_tags.select{|x| unchanged_names.include? x.tag_heading }
			[unchanged_tags, new_names_list]
		end

		def mergeable_tag_names(old_tags, new_names)
			unchanged_tags, new_names_list = updated_tag_values(old_tags, new_names)
			yield(unchanged_tags, new_names_list)
		end

	end

end
