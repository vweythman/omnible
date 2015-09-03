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

	# SCOPES
	# ------------------------------------------------------------
	default_scope { order('name') }

	# NONTABLE VARIABLES
	# ------------------------------------------------------------
	friendly_id :name

	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_many :identities, :inverse_of => :facet
	has_many :descriptions, through: :identities

	# PUBLIC METHODS
	# ------------------------------------------------------------
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

end
