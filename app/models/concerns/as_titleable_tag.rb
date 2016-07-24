require 'active_support/concern'
require 'set'

module AsTitleableTag
	extend ActiveSupport::Concern

	# CLASS METHODS
	# ============================================================
	class_methods do
		def batch_by_title(titles, uploader)
			self.transaction do 
				titles.split(";").map { |title_proper| 
					title_proper.strip!

					work = Work.find_by_title_proper(title_proper)
					work = Work.create_by_title_proper(title_proper, uploader) if work.nil?

					work
				}
			end
		end

		def find_heading_by(title_proper)
			title = title_proper.scan(/^[^\[\]\/]+/).first.strip
		end

		def find_tag_heading_by(title_proper)
			title = title_proper.scan(/^[^\/]+/).first.strip
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

		def create_by_title_proper(title_proper, uploader)
			title   = find_heading_by title_proper
			type    = find_type_by title_proper
			creator = find_creator_name_by title_proper

			create_by_title_values(title, type, creator, uploader)
		end

		def create_by_title_values(title, type, creator, uploader)
			type = "Unsorted" if type.nil?
			work = Record.create(title: title, uploader_id: uploader.id)
			work.qualitatives.create(key: 'medium', value: type)

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
				w = Work.where(title: title).first
			elsif type.nil?
				w = Work.where(title: title).seek_with_creator(creator).first
			elsif creator.nil?
				w = Work.where(title: title).seek_with_type(type).first
			else
				w = Work.where(title: title).seek_with_creator(creator).seek_with_type(type).first
			end
		end

		def merged_tag_names(old_tags, new_names, visitor)
			unchanged_tags, new_names_list = updated_tag_values(old_tags, new_names)
			(unchanged_tags + Work.batch_by_title(new_names_list, visitor))
		end

		def updated_tag_values(current_tags, new_values)
			current_tag_titles = current_tags.map(&:tag_heading)
			current_reg_titles = current_tags.map(&:heading)
			new_names = new_values.split(";")

			unchanged_tag_titles = []
			unchanged_reg_titles = []
			adding_titles        = []

			new_names.map {|n| 
				tag_title = find_tag_heading_by(n)
				reg_title = find_heading_by(n)

				using_type = tag_title != reg_title

				if (using_type && current_tag_titles.include?(tag_title))
					unchanged_tag_titles << tag_title
				elsif (!using_type && current_reg_titles.include?(reg_title))
					unchanged_reg_titles << reg_title
				else
					adding_titles << n.strip
				end
			}

			unchanged_tags_th = current_tags.select{|x| unchanged_tag_titles.include? x.tag_heading }
			unchanged_tags_rh = current_tags.select{|x| unchanged_reg_titles.include? x.heading     }

			unchanged_tags = unchanged_tags_th + unchanged_tags_rh
			new_names_list = adding_titles.join(";")
			
			unchanged_tags.uniq!

			[unchanged_tags, new_names_list]
		end

	end

end
