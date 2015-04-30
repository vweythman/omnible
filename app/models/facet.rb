# Facet
# ================================================================================
# facets belong to the type group, defining identities
#
# ================================================================================

class Facet < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	include Organizer     # member of the type group
	extend FriendlyId     # slugged based on the name

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

end
