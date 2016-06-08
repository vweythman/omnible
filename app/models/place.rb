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
	# ============================================================
	include Documentable
	include Editable
	extend  Organizable
	include AsNameableTag

	# CALLBACKS
	# ============================================================
	before_create     :ensure_defaults
	before_validation :update_tags, on: [:update, :create]

	# SCOPES
	# ============================================================
	scope :order_by_form, -> { includes(:form).order('forms.name, places.name') }
	scope :actual,        -> { where("fictional = 'f'") }
	scope :fictitious,    -> { where("fictional = 't'") }
	scope :alphabetical,  -> { order("lower(places.name) asc") }

	scope :not_among,            ->(place_ids)      { where("id NOT IN (?)", place_ids)                    }
	scope :taggable_places,      ->(exception_list) { not_among(exception_list).includes(:form)            }
	scope :taggable_fake_places, ->(exception_list) { not_among(exception_list).fictitious.includes(:form) }
	scope :taggable_real_places, ->(exception_list) { not_among(exception_list).actual.includes(:form)     }

	# ASSOCIATIONS
	# ============================================================
	# Joins
	# ------------------------------------------------------------
	has_many :localities,    foreign_key: "subdomain_id", dependent: :destroy
	has_many :sublocalities, foreign_key: "domain_id",    dependent: :destroy, class_name: "Locality"

	has_many :locations, dependent: :destroy
	has_many :settings,  dependent: :destroy

	# Belongs To
	# ------------------------------------------------------------
	has_many   :domains, through: :localities
	belongs_to :form

	# Has
	# ------------------------------------------------------------
	has_many :characters, through: :locations
	has_many :subdomains, through: :sublocalities
	has_many :works,      through: :settings

	# NESTED ATTRIBUTION
	# ============================================================
	accepts_nested_attributes_for :localities,    :allow_destroy => true
	accepts_nested_attributes_for :sublocalities, :allow_destroy => true

	# CLASS METHODS
	# ============================================================
	# OrganizedAll
	# - creates an list of all identities organized by form
	def self.organized_all(list = Place.order(:name).includes(:form))
		Place.organize(list)
	end

	def self.batch_real_by_name(names, uploader)
		self.transaction do 
			names.split(";").map { |name| 
				name.strip!
				model = self.where(name: name).first
				model = self.create(name: name, uploader_id: uploader.id, fictional: false) if model.nil?
				model
			}
		end
	end

	# ATTRIBUTES
	# ============================================================
	attr_accessor :domainables, :fictionality, :nature, :subdomainables
	attr_accessor :visitor,     :uptree,       :downtree

	def domainables
		@domainables ||= nil
	end

	def nature
		if @nature.nil?
			@nature = self.form.name unless self.form.nil?
		end
		@nature
	end

	def fictionality
		@fictionality ||= "Fictitious Place"
	end

	def subdomainables
		@subdomainables ||= nil
	end

	def visitor
		@visitor ||= nil
	end

	def uptree
		@uptree ||= 0
	end

	def downtree
		@downtree ||= 0
	end

	# PUBLIC METHODS
	# ============================================================
	# GETTERS
	# ------------------------------------------------------------
	# MODELS
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# Linkable - grab what will be used when organizing
	def linkable
		self
	end

	# STRINGS
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# Heading - defines the main means of addressing the model
	def heading
		name
	end

	# Arrays and Fake Arrays
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def domain_names
		self.domains.map(&:name)
	end

	def domainable_ids
		@domainable_ids ||= unset_id? ? [] : [self.id] + self.domains.pluck(:id)
	end

	def subdomain_names
		self.subdomains.map(&:name)
	end

	def subdomainable_ids
		@subdomainable_ids ||= unset_id? ? [] : [self.id] + self.subdomains.pluck(:id)
	end

	# SETTERS
	# ------------------------------------------------------------
	def domainize
		curr   = domains.includes(:domains)
		domdom = curr.map(&:domains).flatten.uniq
		self.domains << (domdom - self.domains)
	end

	def subdomainize
		curr   = subdomains.includes(:subdomains)
		subsub = curr.map(&:subdomains).flatten.uniq
		self.subdomains << (subsub - self.subdomains)
	end

	def typify(nm = "unspecified")
		self.form = Form.where(name: nm.nil? ? "unspecified" : nm).first_or_create
	end

	# QUESTIONS
	# ------------------------------------------------------------
	def downtree?
		downtree == '1'
	end

	# Fictional? - asks whether the place exists in real life or not
	def fictional?
		self.fictional
	end

	def real?
		!self.fictional
	end

	def unset_id?
		self.id.nil?
	end

	def uptree?
		uptree == '1'
	end

	# PRIVATE METHODS
	# ============================================================
	private

	# EnsureDefaults - default behaivor
	def ensure_defaults
		self.fictional ||= true

		self.editor_level    ||= Editable::PUBLIC
		self.publicity_level ||= Editable::PUBLIC
	end

	def update_tags
		typify(nature)
		self.fictional = fictionality == "Fictitious Place"

		if fictional?
			updated_place_tags(self.domains, domainables)
			updated_place_tags(self.subdomains, subdomainables)
		else
			updated_real_place_tags(self.domains, domainables)
			updated_real_place_tags(self.subdomains, subdomainables)
		end

		if downtree?
			subdomainize
		end

		if uptree?
			domainize
		end
	end

	def organize_tags(old_tags, new_tags)
		unless id.nil?
			old_tags.delete(old_tags - new_tags)
		end
		old_tags <<    (new_tags - old_tags)
	end

	def updated_place_tags(ot, nm)
		unless nm.nil?
			ct = Place.mergeable_tag_names(ot, nm) do|ut, nn|
				(ut +  Place.batch_by_name(nn, visitor))
			end
			organize_tags(ot, ct)
		end
	end

	def updated_real_place_tags(ot, nm)
		unless nm.nil?
			ct = Place.mergeable_tag_names(ot, nm) do|ut, nn|
				(ut +  Place.batch_real_by_name(nn, visitor))
			end
			organize_tags(ot, ct)
		end
	end

end
