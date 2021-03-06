# Appearance
# ================================================================================
# join table, tags works with characters
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable     | type           | about
# --------------------------------------------------------------------------------
#  id           | integer        | unique
#  work_id      | interger       | references work
#  character_id | integer        | references character
#  role         | string         | cannot be null
#  created_at   | datetime       | must be earlier or equal to updated_at
#  updated_at   | datetime       | must be later or equal to created_at
# ================================================================================

class Appearance < ActiveRecord::Base

	# MODULES
	# ============================================================
	extend Organizable

	# VALIDATIONS
	# ============================================================
	validates_uniqueness_of :character_id, :scope => :work_id

	# SCOPES
	# ============================================================
	# SELECT
	# ------------------------------------------------------------
	scope :are_among_for, ->(work, cids) { where("work_id = ? AND character_id IN (?)",     work.id, cids) }
	scope :not_among_for, ->(work, cids) { where("work_id = ? AND character_id NOT IN (?)", work.id, cids) }

	# SUBTYPES
	# ------------------------------------------------------------
	scope :main_character, -> { where(role: "main")      }
	scope :side,           -> { where(role: "side")      }
	scope :mentioned,      -> { where(role: "mentioned") }
	scope :subject,        -> { where(role: "subject")   }

	# ASSOCIATIONS
	# ============================================================
	# BELONGS TO
	# ------------------------------------------------------------
	belongs_to :character
	belongs_to :work

	# SUBTYPES
	# ------------------------------------------------------------
	belongs_to :main_character,      -> { Appearance.main_character }, class_name: "Character", foreign_key: "character_id"
	belongs_to :side_character,      -> { Appearance.side },           class_name: "Character", foreign_key: "character_id"
	belongs_to :mentioned_character, -> { Appearance.mentioned },      class_name: "Character", foreign_key: "character_id"
	belongs_to :people_subject,      -> { Appearance.subject },        class_name: "Character", foreign_key: "character_id"

	# CLASS METHODS
	# ============================================================
	# Roles - defines and collects the types of appearances
	def self.roles(work)
		self.roles_by_type(work.narrative?)
	end

	def self.roles_by_type(is_narrative)
		if is_narrative
			narrative_labels
		else
			nonfiction_labels
		end
	end

	def self.narrative_labels
		['main', 'side', 'mentioned']
	end

	def self.nonfiction_labels
		['subject']
	end

	def self.tag_labels(work)
		if work.narrative?
			labels = narrative_labels
			labels.map { |label|
				{
					:label   => label,
					:heading => "#{label.titleize} Characters"
				}
			}
		else
			labels = nonfiction_labels
			labels.map { |label|
				{
					:label   => label,
					:heading => "#{label.titleize} (People)"
				}
			}
		end
	end

	# UpdateFor - add and change appearances for work
	def self.update_for(model, grouped_ids)
		Appearance.transaction do
			character_ids = Array.new
			grouped_ids.map{ |role, ids|

				character_ids.concat ids

				ids.each do |id|
					current = Appearance.are_among_for(model, [id]).first

					# create
					if current.nil?
						Appearance.where(work_id: model.id, character_id: id, role: role).create
					# update role
					elsif current.role != role
						current.role = role
						current.save
					end
				end
			}
			remove = Appearance.not_among_for(model, character_ids).destroy_all
		end
	end

	# PUBLIC METHODS
	# ============================================================
	# Type - defines the type name if it exists
	def nature
		self.role
	end

	# Linkable - grab what will be used when organizing
	def linkable
		self.character
	end

end
