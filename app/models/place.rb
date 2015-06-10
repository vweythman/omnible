class Place < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	include Documentable  # member of the subject group
	extend Organizable    # has a type

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :form

	# METHODS
	# ------------------------------------------------------------
	# Heading
	# - defines the main means of addressing the model
	def heading
		"#{form.name.titleize} / #{name}"
	end

	# Type
	# - defines the type name if it exists
	def type
		self.form.name unless self.form.nil?
	end

	# CLASS METHODS
	# ------------------------------------------------------------
	# OrganizedAll
	# - creates an list of all identities organized by form
	def self.organized_all(list = Place.order(:name).includes(:form))
		Place.organize(list)
	end

end
