# Facet
# ================================================================================
# categories for identities
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable     | type        | about
# --------------------------------------------------------------------------------
#  id           | integer     | unique
#  name         | string      | maximum of 250 characters
#  created_at   | datetime    | must be earlier or equal to updated_at
#  updated_at   | datetime    | must be later or equal to created_at
# ================================================================================

class Facet < ActiveRecord::Base

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :name, length: { maximum: 250 }, presence: true

	# MODULES
	# ------------------------------------------------------------
	extend FriendlyId
	include EditableCategory

	# SCOPES
	# ------------------------------------------------------------
	scope :alphabetic,         -> { order('lower(name) ASC') }
	scope :reverse_alphabetic, -> { order('lower(name) DESC') }

	scope :alphabetic_next, ->(facet) { where('lower(name) > ?', facet.name.downcase).alphabetic         }
	scope :alphabetic_prev, ->(facet) { where('lower(name) < ?', facet.name.downcase).reverse_alphabetic }

	# NONTABLE VARIABLES
	# ------------------------------------------------------------
	friendly_id :name

	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_many :identities,   :inverse_of => :facet
	has_many :descriptions, through: :identities
	has_many :characters,   through: :descriptions

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def heading
		@heading ||= name
	end

	# Piedata - organizes facet data for use in pie charts
	def piedata
		list  = Array.new
		label = self.descriptions.joins(:identity).group("identities.name").order("identities.name").count
		label.each do |key, val|
			h = Hash.new
			h[:label] = key
			h[:value] = val
			list << h
		end
		return list
	end

	# FacetedNext - next in facet
	def alphabetic_next
		@alphabetic_next ||= Facet.alphabetic_next(self).first
	end

	# FacetedPrev - previous in facet
	def alphabetic_prev
		@alphabetic_prev ||= Facet.alphabetic_prev(self).first
	end

end
