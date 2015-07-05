# Character
# ================================================================================
# characters belong to the subject group of tags
#
# Variables (max length: 15 characters) 
# --------------------------------------------------------------------------------
#  variable name   | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  name            | string      | maximum of 250 characters
#  form_id         | integer     | references form, cannot be null
#  fictional       | boolean     | cannot be null
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
#
# Methods (max length: 25 characters) 
# --------------------------------------------------------------------------------
#  method name                 | output type | description
# --------------------------------------------------------------------------------
#  heading                     | string      | defines the main means of
#                              |             | addressing the model
#  interconnections                 | string      | defines the type name if it exists
#  fictional?                  | bool        | asks whether the place exists in 
#                              |             | real life or not
# ================================================================================

class Place < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	include Documentable
	extend Organizable

	# CALLBACKS
	# ------------------------------------------------------------
	after_save :build_place_relationships

	# SCOPES
	# ------------------------------------------------------------
	scope :fictitious, -> { where("fictional = 't'") }
	scope :actual,     -> { where("fictional = 'f'") }
	scope :not_among,  ->(place_ids) { where("id NOT IN (?)", place_ids) }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	# joins
	has_many :localities,    foreign_key: "subdomain_id", dependent: :destroy
	has_many :sublocalities, class_name: "Locality", foreign_key: "domain_id", dependent: :destroy
	
	# models that possess these models
	belongs_to :form
	has_many :domains, through: :localities

	# models that belong to this model
	has_many :subdomains, through: :sublocalities

	# ------------------------------------------------------------
	accepts_nested_attributes_for :localities,    :allow_destroy => true
	accepts_nested_attributes_for :sublocalities, :allow_destroy => true

	# METHODS
	# ------------------------------------------------------------
	# Heading
	# - defines the main means of addressing the model
	def heading
		"#{form.name.titleize} / #{name}"
	end

	# Type
	# - defines the type name if it exists
	def nature
		self.form.name unless self.form.nil?
	end

	# Fictional?
	# asks whether the place exists in real life or not
	def fictional?
		self.fictional
	end

	# PotentialDomains
	# - find all potential domains
	def potential_domains
		if self.id.nil?
			Place.all.includes(:form)
		else
			# fictional places cannot contain real places
			subdomains = [self.id] + self.subdomains.pluck(:id)
			domains    = self.fictional? ? Place.not_among(subdomains).includes(:form) : Place.actual.not_among(subdomains).includes(:form)
		end
	end

	# PotentialSubomains
	# - find all potential subdomains
	def potential_subdomains
		if self.id.nil?
			Place.all.includes(:form)
		else
			# fictional places cannot contain real places
			domains    = [self.id] + self.domains.pluck(:id)
			subdomains = self.fictional? ? Place.fictitious.not_among(domains).includes(:form) :  Place.not_among(domains).includes(:form)
		end
	end

	def build_place_relationships
		Locality.batch_missing(self) unless self.id.nil?
	end

	# CLASS METHODS
	# ------------------------------------------------------------
	# OrganizedAll
	# - creates an list of all identities organized by form
	def self.organized_all(list = Place.order(:name).includes(:form))
		Place.organize(list)
	end

end
