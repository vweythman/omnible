# CharacterInfo
# ================================================================================
# join table, anthologies has works
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  title           | string      | maximum of 250 characters
#  content         | text        | cannot be null
#  character_id    | integer     | ref
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
# ================================================================================

class CharacterInfo < ActiveRecord::Base

	# VALIDATIONS
	# ============================================================
	validates :title,   length: { maximum: 250 }
	validates :content, presence: true


	# ASSOCIATIONS
	# ============================================================
	belongs_to :character

end
