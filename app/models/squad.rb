# Group
# ================================================================================
# a type of subject
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  name            | string      | maximum of 250 characters
#  description     | text        | can be null
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
#  uploader_id     | integer     | references user
# ================================================================================

class Squad < ActiveRecord::Base
	
	# CALLBACKS
	# ============================================================
	before_validation :update_tags, on: [:update, :create]

	# MODULES
	# ============================================================
	include Editable
	include AsNameableTag
	include Documentable

	# Counts
	# ------------------------------------------------------------
	scope :count_by_name,  -> { group(:name).ordered_count  }

	# ASSOCIATIONS
	# ============================================================
	# Joins
	# ------------------------------------------------------------
	has_many :social_appearances,               dependent: :destroy, foreign_key: "social_group_id"
	has_many :memberships,                      dependent: :destroy, foreign_key: "social_group_id"
	has_many :taggings, -> { Tagging.quality }, dependent: :destroy, as: :tagger

	# Has Many
	# ------------------------------------------------------------
	# - Tags
	has_many :members,      through: :memberships
	has_many :quality_tags, through: :taggings
	has_many :works,        through: :social_appearances

	# - Subtype
	has_many :characters,       through: :memberships, source: :member, source_type: "Character"
	has_many :interconnections, through: :memberships, source: :member, source_type: "Interconnection"

	# - Secondary
	has_many :left_bound_characters,  through: :interconnections, source: :left
	has_many :right_bound_characters, through: :interconnections, source: :right

	# ATTRIBUTES
	# ============================================================
	attr_accessor :visitor, :people, :tags, :relateables

	def qualities
		quality_tags
	end

	def people
		@people ||= nil
	end

	def relateables
		@relateables ||= nil
	end

	def tags
		@tags ||= nil
	end

	def visitor
		@visitor ||= nil
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def update_tags
		unless tags.nil?
			old_tags     = self.quality_tags
			current_tags = Tag.merged_tag_names(old_tags, tags, visitor)
			organize_tags(old_tags, current_tags)
		end

		unless people.nil?
			old_tags     = self.characters
			current_tags = Character.merged_tag_names(old_tags, people, visitor)
			organize_tags(old_tags, current_tags)
		end

		organize_tags(self.interconnections, current_relationships) unless relateables.nil?
	end
	
	def current_relationships
		list      = []
		all_chars = {}
		relators  = {}

		relateables.delete!("\n")
		relateables.split(";").each do |y|
			l, c   = y.split(":")
			ls     = l.split("/").map{|n| n.singularize.downcase }
			n0, n1 = c.split("&").map{|n| n.strip }

			if all_chars[n0].nil?
				c0 = all_chars[n0] = Character.tag_creation(n0, visitor)
			else
				c0 = all_chars[n0]
			end

			if all_chars[n1].nil?
				c1 = all_chars[n1] = Character.tag_creation(n1, visitor)
			else
				c1 = all_chars[n1]
			end

			if relators[ls[0]].nil?
				rel = relators[ls[0]] = relator_name(ls)
			else
				rel = relators[ls[0]]
			end
			
			if ls.length > 1
				i = Interconnection.seekout(rel, c0, c1)
			else		
				i = Interconnection.unspecific_seekout(rel, c0, c1)
			end
			list << i
		end
		list
	end

	def relator_name(ls)
		ls.length > 1 ? Relator.specific(ls[0], ls[1]).first : Relator.find_by_left_name(ls[0])
	end

	def organize_tags(old_tags, new_tags)
		old_tags.delete(old_tags - new_tags)
		old_tags <<    (new_tags - old_tags)
	end

end
