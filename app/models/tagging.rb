# Tagging
# ================================================================================
# join table, for works
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  work_id         | integer     | references work
#  tag_id          | integer     | references tag
#  created_at      | datetime    | <= updated_at
#  updated_at      | datetime    | >= created_at
# ================================================================================

class Tagging < ActiveRecord::Base

	# SCOPES
	# ------------------------------------------------------------
	scope :not_among_for, ->(work, tag_ids) { where("work_id = ? AND tag_id NOT IN (?)", work.id, tag_ids) }
	scope :are_among_for, ->(work, tag_ids) { where("work_id = ? AND tag_id IN (?)",     work.id, tag_ids) }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :tagger, polymorphic: true
	belongs_to :tag

	def self.update_for(model, list)
		if list.length > 0
			Tagging.transaction do
				remove  = Tagging.not_among_for(model, list).destroy_all
				current = Tagging.are_among_for(model, list).pluck(:id)

				to_be_added = list - current

				to_be_added.each do |id|
					Tagging.where(work_id: model.id, tag_id: id).first_or_create
				end
			end
		else
			model.taggings.destroy_all
		end
	end

end
