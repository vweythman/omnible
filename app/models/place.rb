# Place
# ================================================================================
# a type of subject
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  name            | string      | maximum of 250 characters
#  form_id         | integer     | references form, cannot be null
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
#  fictional       | boolean     | cannot be null
#  editor_level    | integer     | cannot be null
#  publicity_level | integer     | cannot be null
#  uploader_id     | integer     | references user
# ================================================================================

class Place < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	include Documentable
	extend Organizable

	# CALLBACKS
	# ------------------------------------------------------------
	after_save :build_place_relationships
	before_create :ensure_defaults

	# SCOPES
	# ------------------------------------------------------------
	scope :fictitious, -> { where("fictional = 't'") }
	scope :actual,     -> { where("fictional = 'f'") }
	scope :not_among,  ->(place_ids) { where("id NOT IN (?)", place_ids) }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	# - Joins
	has_many :localities, foreign_key: "subdomain_id", dependent: :destroy
	has_many :locations
	has_many :settings
	has_many :sublocalities, foreign_key: "domain_id", dependent: :destroy, class_name: "Locality"

	# - Belongs to
	has_many   :domains, through: :localities
	belongs_to :form

	# - Has
	has_many :characters, through: :locations
	has_many :subdomains, through: :sublocalities
	has_many :works,      through: :settings

	# NESTED ATTRIBUTION
	# ------------------------------------------------------------
	accepts_nested_attributes_for :localities,    :allow_destroy => true
	accepts_nested_attributes_for :sublocalities, :allow_destroy => true

	# CLASS METHODS
	# ------------------------------------------------------------
	# OrganizedAll
	# - creates an list of all identities organized by form
	def self.organized_all(list = Place.order(:name).includes(:form))
		Place.organize(list)
	end

	def self.batch_by_name(str, user)
		names = str.split(";")
		ids   = Array.new

		Place.transaction do
			names.each do |name|
				name.strip!
				place = Place.where(name: name).first_or_create
				place.uploader_id ||= user.id
				place.save
				ids << place.id
			end
		end

		ids
	end

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# Heading - defines the main means of addressing the model
	def heading
		"#{form.name.titleize} / #{name}"
	end

	# Nature - defines the type name if it exists
	def nature
		self.form.name unless self.form.nil?
	end

	# Linkable - grab what will be used when organizing
	def linkable
		self
	end

	# PotentialDomains - find all potential domains
	def potential_domains
		if self.id.nil?
			Place.all.includes(:form)
		else
			# fictional places cannot contain real places
			subdomains = [self.id] + self.subdomains.pluck(:id)
			domains    = self.fictional? ? Place.not_among(subdomains).includes(:form) : Place.actual.not_among(subdomains).includes(:form)
		end
	end

	# PotentialSubomains - find all potential subdomains
	def potential_subdomains
		if self.id.nil?
			Place.all.includes(:form)
		else
			# fictional places cannot contain real places
			domains    = [self.id] + self.domains.pluck(:id)
			subdomains = self.fictional? ? Place.fictitious.not_among(domains).includes(:form) :  Place.not_among(domains).includes(:form)
		end
	end

	# Fictional? - asks whether the place exists in real life or not
	def fictional?
		self.fictional
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# BuildPlaceRelationships
	def build_place_relationships
		Locality.batch_missing(self) unless self.id.nil?
	end

	# EnsureDefaults - default behaivor
	def ensure_defaults
		self.fictional ||= true
		self.form_id   ||= 16

		self.editor_level    ||= Editable::PUBLIC
		self.publicity_level ||= Editable::PUBLIC
	end

end
