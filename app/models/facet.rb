# Facet
# ================================================================================
# facets belong to the type group, defining identities
#
# ================================================================================

class Facet < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	extend FriendlyId

	# VALIDATIONS and SCOPES
	# ------------------------------------------------------------
	default_scope {order('name')}
	validates :name, length: { maximum: 250 }, presence: true

	# NONTABLE VARIABLES
	# ------------------------------------------------------------
	friendly_id :name

	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_many :identities, :inverse_of => :facet
	has_many :descriptions, through: :identities

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
