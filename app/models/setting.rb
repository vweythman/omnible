# Setting
# ================================================================================
# join table, tags works with places
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable     | type           | about
# --------------------------------------------------------------------------------
#  id           | integer        | unique
#  work_id      | integer        | references work
#  place_id     | integer        | references place
#  created_at   | datetime       | must be earlier or equal to updated_at
#  updated_at   | datetime       | must be later or equal to created_at
# ================================================================================

class Setting < ActiveRecord::Base

	# SCOPES
	# ------------------------------------------------------------
	scope :are_among_for, ->(work, ids) { where("work_id = ? AND place_id IN (?)",     work.id, ids) }
	scope :not_among_for, ->(work, ids) { where("work_id = ? AND place_id NOT IN (?)", work.id, ids) }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :work
	belongs_to :place

	# CLASS METHODS
	# ------------------------------------------------------------
	def self.update_for(model, list)
		if list.length > 0
			Setting.transaction do
				remove  = Setting.not_among_for(model, list).destroy_all
				current = Setting.are_among_for(model, list).pluck(:id)

				to_be_added = list - current

				to_be_added.each do |id|
					Setting.where(work_id: model.id, place_id: id).first_or_create
				end
			end
		else
			model.settings.destroy_all
		end
	end

end
