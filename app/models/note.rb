# Note
# ================================================================================
# subpart of works
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  title           | string      | maximum of 250 characters
#  content         | text        | cannot be null
#  work_id         | integer     | cannot be null
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
# ================================================================================

class Note < ActiveRecord::Base

	# VALIDATIONS
	# ============================================================
	validates :content, presence: true

	# MODULES
	# ============================================================
	include Discussable
	include Titleizeable

	# CALLBACKS
	# ============================================================
	#after_save :cascade_data

	# ASSOCIATIONS
	# ============================================================
	belongs_to :work

	# DELEGATED METHODS
	# ============================================================
	delegate :uploader, to: :work
	
	# ATTRIBUTES
	# ============================================================
	alias_attribute :about, :summary
	
	# METHODS
	# ============================================================
	# Heading - defines the main means of addressing the model
	def heading
		if title.empty?
			"Note"
		else
			title
		end
	end

	# JustCreated? - self explanatory
	def just_created?
		self.updated_at == self.created_at
	end
	
	def word_count
		body = self.content.downcase.gsub(/[^[:word:]\s]/, '')
		I18n.transliterate(body).scan(/[a-zA-Z]+/).size
	end

	# Editable - user is allowed to edit
	def editable?(user)
		self.work.editable? user
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def cascade_data
		if self.work.updated_at != self.updated_at
			self.work.updated_at = self.updated_at
			self.work.save
		end
	end

	def default_heading
		"Note"
	end

end
