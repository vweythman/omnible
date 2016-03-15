require 'active_support/concern'

module AsTitleableTag
	extend ActiveSupport::Concern

	# CLASS METHODS
	# ============================================================
	class_methods do
		def batch_by_title(titles, uploader)
			self.transaction do 
				titles.split(";").map { |title_proper| 
					title_proper.strip!

					title, type, creator = find_title_values(title_proper)

					work = find_with_title_values(title, type, creator)
					work = create_by_title_values(title, type, creator, uploader) if work.nil?

					work
				}
			end
		end

		def find_heading_by(title_proper)
			title = title_proper.scan(/^[^\[\]\/]+/).first.strip
		end

		def find_type_by(title_proper)
			found_type = title_proper.scan(/\[[\w\s]*\]/).first
			found_type = found_type.strip.gsub(/[\[\]]/, "") unless found_type.nil?
		end

		def find_creator_name_by(title_proper)
			found_name = title_proper.scan(/\/\s[^\[\]\/]+/).first
			found_name = found_name.gsub(/[\/]/, "").strip unless found_name.nil?
		end

		def find_title_values(title_proper)
			title   = find_heading_by title_proper
			type    = find_type_by title_proper
			creator = find_creator_name_by title_proper
			[title, type, creator]
		end

		def create_by_title_values(title, type, creator, uploader)
			work = Record.create(title: title, uploader_id: uploader.id)
			work.metadata.create(key: 'medium', value: type) unless type.nil?
			unless creator.nil?
				person = Character.where(name: creator).first
				person = Character.create_person(creator, uploader) if person.nil?
				work.creatorships.create(creator_id: person.id)
			end
			work
		end

		def find_by_title_proper(title_proper)
			title   = find_heading_by title_proper
			type    = find_type_by title_proper
			creator = find_creator_name_by title_proper

			find_with_title_values(title, type, creator)
		end

		def find_with_title_values(title, type, creator)
			if type.nil? && creator.nil?
				where(title: title).first
			elsif type.nil?
				where(title: title).seek_with_creator(creator).first
			elsif creator.nil?
				where(title: title).seek_with_type(type).first
			else
				where(title: title).seek_with_creator(creator).seek_with_type(type).first
			end
		end

		def merged_tag_names(old_tags, new_names, visitor)
			unchanged_tags, new_names_list = updated_tag_values(old_tags, new_names)
			(unchanged_tags + batch_by_title(new_names_list, visitor))
		end

		def updated_tag_values(current_tags, new_values)
			current_names = current_tags.map(&:heading)
			clean_names   = new_values.split(";").map {|n| Work.find_heading_by n.strip }

			unchanged_names = current_names & clean_names
			new_names_list  = (clean_names - current_names).join(";")

			unchanged_tags  = current_tags.select{|x| unchanged_names.include? x.heading }
			[unchanged_tags, new_names_list]
		end

	end

end
