# Appearance
# ================================================================================
# appearance is a join model for works and characters
#
# Methods (max length: 25 characters) 
# --------------------------------------------------------------------------------
#  method name                 | output type | description
# --------------------------------------------------------------------------------
#  self.roles                  | array       | defines and collects the types of 
#                              |             | appearances
# ================================================================================

class Appearance < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	extend Organizable

	# SCOPES
	# ------------------------------------------------------------
	scope :are_among_for, ->(work, cids) { where("work_id = ? AND character_id IN (?)", work.id, cids)}
	scope :not_among_for, ->(work, cids) { where("work_id = ? AND character_id NOT IN (?)", work.id, cids)}

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :character
	belongs_to :work

	belongs_to :main_character, -> { where("appearances.role = 'main'")}, class_name: "Character", foreign_key: "character_id"
	belongs_to :side_character, -> { where("appearances.role = 'side'")}, class_name: "Character", foreign_key: "character_id"

	belongs_to :subject,  -> { where("appearances.role = 'subject'")},   class_name: "Character", foreign_key: "character_id"
	belongs_to :appearer, -> { where("appearances.role = 'appearing'")}, class_name: "Character", foreign_key: "character_id"

	belongs_to :mentioned_character, -> { where("appearances.role = 'mentioned'")}, class_name: "Character", foreign_key: "character_id"

	# Type
	# - defines the type name if it exists
	def nature
		self.role
	end

	# Linkable
	# - grab what will be used when organizing
	def linkable
		self.character
	end

	# CLASS METHODS
	# ------------------------------------------------------------
	# Hashing - organize values by roles
	def self.hashing(work, work_params)
		tags = Array.new
		self.roles(work).map {|role|
			tagging = work_params[role].split(";")
			tags    = tags + tagging.map {|tagged| { :role => role, :name => tagged } }
		}
		return tags
	end

	# - inits a hash of arrays with the roles as keys
	def self.init_hash(work)
		lst = {}
		self.roles(work).map {|role| lst[role] = Array.new }
		return lst
	end

	# Roles
	# - defines and collects the types of appearances
	def self.roles(work)
		if work.narrative?
			['main', 'side', 'mentioned']
		else
			['subject', 'appearing', 'mentioned']
		end
	end

	# UpdateFor
	# - 
	def self.update_for(work, work_params)
		orig = work.appearances.joins(:character).pluck(:name, :role, :character_id)
		curr = hashing(work, work_params)
		delt = Array.new
		updt = init_hash(work)

		orig.map {|character|
			idx = curr.index { |i| i[:name] == character[0] }
			
			if idx.nil?
				delt << character[2]
			else
				item = curr[idx]
				role = item[:role]
				if character[1] != role
					updt[role] << character[2]
				else
					curr.delete_at(idx)
				end
			end
		}

		self.are_among_for(work, delt).destroy_all
		updt.map {|role, cids| self.are_among_for(work, cids).update_all(:role => role) }
		return curr
	end

end
