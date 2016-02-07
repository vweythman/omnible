# Identity
# ================================================================================
# tags for characters
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable     | type           | about
# --------------------------------------------------------------------------------
#  id           | integer        | unique
#  name         | string         | maximum of 250 characters
#  facet_id     | integer        | references facet
#  created_at   | datetime       | must be earlier or equal to updated_at
#  updated_at   | datetime       | must be later or equal to created_at
# ================================================================================
class Identity < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	extend  Organizable
	include EditableTag
	include Taggable

	# SCOPES
	# ------------------------------------------------------------
	# - Search
	scope :are_among, ->(names) { where("name IN (?)", names) }

	# - Order
	scope :alphabetic,         -> { order('lower(name) ASC') }
	scope :reverse_alphabetic, -> { order('lower(name) DESC') }
	scope :sorted_alphabetic,  -> { joins(:facet).order('lower(facets.name) ASC, lower(identities.name) ASC') }

	# - Types
	scope :ages,    -> { where(facet: 'age') }
	scope :genders, -> { where(facet: 'gender') }

	# - Associated
	scope :alphabetic_next, ->(identity) { where('lower(name) > ?', identity.name.downcase).alphabetic }
	scope :alphabetic_prev, ->(identity) { where('lower(name) < ?', identity.name.downcase).reverse_alphabetic }
	scope :next_in_facet,   ->(identity) { where('facet_id = ? AND lower(name) > ?', identity.facet_id, identity.name.downcase).alphabetic }
	scope :prev_in_facet,   ->(identity) { where('facet_id = ? AND lower(name) < ?', identity.facet_id, identity.name.downcase).reverse_alphabetic }
	scope :related,         ->(identity) { where("identities.id != ?", identity.id).joins(:descriptions).merge(Description.within(identity)).with_count(identity).select("COUNT(*) as amt")}
	
	# - Divide
	scope :with_count, ->(identity) { group("identities.id").order("COUNT(*) DESC").select("identities.*, (SELECT COUNT(*) FROM descriptions WHERE descriptions.identity_id = identities.id) as full_count")}

	# ASSOCIATIONS
	# -----------------------------------------------------------
	# - Joins
	has_many :descriptions

	# - Belongs to
	has_many :characters, through: :descriptions
	belongs_to :facet, :inverse_of => :identities

	# - References
	has_many :appearances, source: :appearance, through: :descriptions
	has_many :works, ->{uniq}, source: :work, through: :appearances

	# NESTED ATTRIBUTION
	# ------------------------------------------------------------
	accepts_nested_attributes_for :descriptions, :allow_destroy => true

	# CLASS METHODS
	# ------------------------------------------------------------
	# OrganizedAll - creates an list of all identities organized by facet
	def self.organized_all(list = Identity.includes(:facet).alphabetic)
		Identity.organize(list)
	end

	def self.faceted_line_batch(facet_id, str)
		list  = Array.new

		str.split(";").each do |name|
			name.strip!
			identity = Identity.where(name: name, facet_id: facet_id).first_or_create
			list << identity
		end

		return list
	end

	def self.faceted_find_by(group)
		list = Array.new

		Identity.transaction do
			Facet.all.each do |facet|
				names      = group[facet.name].nil? ? "" : group[facet.name]
				identities = Identity.faceted_line_batch(facet.id, names)

				list.push(*identities)
			end
		end

		return list
	end

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GETTERS // SELF
	# ............................................................
	# Heading - defines the main means of addressing the model
	def heading
		"#{facet.name}: #{name}"
	end

	# Nature - returns the facet name when it exists
	def nature
		facet.name unless facet.nil?
	end

	# Linkable - grab what will be used when organizing
	def linkable
		self
	end

	# GETTERS // RELATED MODELS
	# ............................................................
	# FacetedNext - next in facet
	def alphabetic_next
		@alphabetic_next ||= Identity.alphabetic_next(self).first
	end

	# FacetedPrev - previous in facet
	def alphabetic_prev
		@alphabetic_prev ||= Identity.alphabetic_prev(self).first
	end

	# FacetedNext - next in facet
	def faceted_next
		@faceted_next ||= Identity.next_in_facet(self).first
	end

	# FacetedPrev - previous in facet
	def faceted_prev
		@faceted_prev ||= Identity.prev_in_facet(self).first
	end

	# Identity - finds identities commonly used together
	def relatives(lim = 5)
		Identity.related(self).limit(lim)
	end

	# SETTERS
	# ............................................................
	# Typify - set the facet type of the identity
	def typify(name)
		self.facet = Facet.where(name: name).first_or_create
	end

	# CALCS
	# ............................................................
	# CharacterPercent - percent of all characters with identity
	def character_percent
		1.0 * self.characters.count / Character.count * 100.0
	end

	# WorkPercent - percent of all works where characters with identity appear
	def work_percent
		1.0 * self.works.count / Work.count * 100.0
	end

	# UseCount - how often
	def use_count
		@usage_count ||= self.characters.count
	end

	# QUESTIONS
	# ............................................................
	def editable? user
		user.staffer?
	end
	
end
