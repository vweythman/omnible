# Interconnection
# ================================================================================
# join table, relationships between characters
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable     | type           | about
# --------------------------------------------------------------------------------
#  id           | integer        | unique
#  left_id      | integer        | references character
#  relator_id   | integer        | references relator
#  right_id     | integer        | references character
#  created_at   | datetime       | must be earlier or equal to updated_at
#  updated_at   | datetime       | must be later or equal to created_at
# ================================================================================

class Interconnection < ActiveRecord::Base

	# SCOPES
	# ============================================================
	validates :left_id,    presence: true
	validates :relator_id, presence: true
	validates :right_id,   presence: true

	# SCOPES
	# ============================================================
	# - Order
	scope :simple_order, -> { order(:relator_id, :left_id, :right_id) }

	# - Collected IDs
	scope :in_left,      ->(cids) { where("left_id  IN (?)", cids) }
	scope :in_right,     ->(cids) { where("right_id IN (?)", cids) }
	scope :not_in_left,  ->(cids) { where("left_id  NOT IN (?)", cids) }
	scope :not_in_right, ->(cids) { where("right_id NOT IN (?)", cids) }

	# - By Relator
	scope :related_by, ->(relator_id) { where(:relator_id => relator_id) }

	# - By Character
	scope :left_relations_for,  ->(person_id) { where(:left_id => person_id) }
	scope :relations_for,       ->(person_id) { where("left_id = ? OR right_id = ?", person_id, person_id)}
	scope :right_relations_for, ->(person_id) { where(:right_id => person_id) }
	scope :crosssection,        ->(p1, p2)    { where("(left_id = ? AND right_id = ?) OR (left_id = ? AND right_id = ?)", p1, p2, p2, p1)}

	# - By Relator and Character
	scope :specific_left_relations_for,  ->(person_id, relator_id) { left_relations_for(person_id).related_by(relator_id) }
	scope :specific_right_relations_for, ->(person_id, relator_id) { right_relations_for(person_id).related_by(relator_id) }

	# - Collected by Relator and Character
	scope :specific_left_among_for,      ->(person_id, relator_id, cids) { specific_left_relations_for(person_id, relator_id).in_left(cids) }
	scope :specific_left_not_among_for,  ->(person_id, relator_id, cids) { specific_left_relations_for(person_id, relator_id).not_in_left(cids) }
	scope :specific_right_among_for,     ->(person_id, relator_id, cids) { specific_right_relations_for(person_id, relator_id).in_right(cids) }
	scope :specific_right_not_among_for, ->(person_id, relator_id, cids) { specific_right_relations_for(person_id, relator_id).not_in_right(cids) }
	
	# ASSOCIATIONS
	# ============================================================
	belongs_to :left, class_name: "Character"
	belongs_to :relator
	belongs_to :right, class_name: "Character"

	has_many :memberships, dependent: :destroy, as: :member
	has_many :social_groups, through: :memberships

	# DELEGATED METHODS
	# ============================================================
	delegate :right_heading, :left_heading, to: :relator

	# CLASS METHODS
	# ============================================================
	# Organize - sort and group similar interconnections
	def self.organize(interconnections, character)
		list = Hash.new
		interconnections.map { |interconnection|
			heading, linkable = interconnection.flip(character)
			list[heading] = Array.new if list[heading].nil?
			list[heading] << linkable
		}
		return list
	end

	def self.update_for(character, list, visitor)
		groups = Interconnection.related_find_by(list, visitor)
		character.relation_set

		Interconnection.transaction do
			groups.map {|direction, grouped_ids|
				grouped_ids.map {|relateables|
					rid = relateables[:relator_id].to_i
					ids = relateables[:list]
					Interconnection.update_for_crossroad(direction, character, rid, ids)
				}
			}
		end
	end

	# FIND AND CREATE
	def self.related_find_by(curr, visitor)
		tags  = Hash.new

		Interconnection.transaction do
			curr.map { |direction, group|
				tags[direction] = Array.new

				group.map { |relator_id, names|
					tags[direction] << {
						:relator_id => relator_id, 
						:list       => Character.batch_by_name(names, visitor).map{ |c| c.id }
					}
				}
			}
		end

		return tags
	end

	def self.full_build(lcid, rid, rcid)
		Interconnection.where(left_id: lcid, relator_id: rid, right_id: rcid).first_or_create
	end

	def self.seekout(rel, lft, rgt)
		self.full_build(lft.id, rel.id, rgt.id)
	end

	def self.unspecific_seekout(rel, left, right)
		i = self.related_by(rel.id).crosssection(left.id, right.id).first
		if i.nil?
			self.full_build(left.id, rel.id, right.id)
		end
		i
	end

	# PRIVATE CLASS METHODS
	# ============================================================
	def self.directed_relations_for(person_id, relator_id, direction = :left)
		if direction == :left
			specific_left_relations_for(person_id, relator_id).includes(:left)
		else
			specific_right_relations_for(person_id, relator_id).includes(:right)
		end
	end

	def self.directionless_relations_for(person_id, relator_id)
		specific_left_relations_for(person_id, relator_id).includes(:left) + specific_right_relations_for(person_id, relator_id).includes(:right)
	end

	def self.remove_left(character, relator_id, ids)
		if ids.length < 1
			Interconnection.specific_left_relations_for(character.id, relator_id).destroy_all
		else
			Interconnection.specific_left_not_among_for(character.id, relator_id, ids).destroy_all
		end
	end

	def self.remove_right(character, relator_id, ids)
		if ids.length < 1
			Interconnection.specific_right_relations_for(character.id, relator_id).destroy_all
		else
			Interconnection.specific_right_not_among_for(character.id, relator_id, ids).destroy_all
		end
	end

	def self.update_for_crossroad(direction, character, relator_id, ids)
		if direction == "right"
			Interconnection.update_right_relation_for(character, relator_id, ids)
		elsif direction == "left"
			Interconnection.update_left_relation_for(character, relator_id, ids)
		else
			Interconnection.update_either_relation_for(character, relator_id, ids)
		end
	end

	def self.update_left_relation_for(character, relator_id, ids)
			lset = character.get_lrset(relator_id)
			nset = ids  - lset
			dset = lset - ids
			
			if dset.nil? || dset.length > 0
				Interconnection.remove_left(character, relator_id, ids)
			end

			nset.each do |id|
				Interconnection.full_build(id, relator_id, character.id)
			end unless nset.nil?
	end

	def self.update_right_relation_for(character, relator_id, ids)
			rset = character.get_rrset(relator_id)
			nset = ids  - rset
			dset = rset - ids

			if dset.nil? || dset.length > 0
				Interconnection.remove_right(character, relator_id, ids)
			end

			nset.each do |id|
				Interconnection.full_build(character.id, relator_id, id)
			end unless nset.nil?
	end

	def self.update_either_relation_for(character, relator_id, ids)
			lset  = character.get_lrset(relator_id)
			rset  = character.get_rrset(relator_id)

			nset  = ids  - (lset + rset)
			drset = rset - ids
			dlset = lset - ids

			if drset.nil? || drset.length > 0
				Interconnection.remove_right(character, relator_id, ids)
			end

			if dlset.nil? || dlset.length > 0
				Interconnection.remove_left(character, relator_id, ids)
			end

			nset.each do |id|
				Interconnection.full_build(character.id, relator_id, id)
			end unless nset.nil?
	end

	# PUBLIC METHODS
	# ============================================================
	# Flip - determine the correct relator heading and character
	def flip(character)
		if self.left.id == character.id
			[self.right_heading, self.right]
		else
			[self.left_heading, self.left]
		end
	end

	def seek_by(value)
		case value
		when :left_name
			left.name
		when :right_name
			right.name
		when :left_id
			left_id
		when :right_id
			right_id
		else
			relator_id
		end
	end

	def left_name
		@left_name ||= left.name
	end

	def right_name
		@right_name ||= right.name
	end

	def data_heading
		label      = relator.data_heading
		left_name  = left.name
		right_name = right.name
		"#{label}: #{left_name} & #{right_name}"
	end

end
