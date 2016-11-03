# Picture
# ================================================================================
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable     | type           | about
# --------------------------------------------------------------------------------
#  id           | integer        | unique
#  work_id      | integer        | references work
#  title        | string         | 
#  artwork      | string         | 
#  description  | text           | 
#  created_at   | datetime       | must be earlier or equal to updated_at
#  updated_at   | datetime       | must be later or equal to created_at
# ================================================================================

require 'file_size_validator'

class Picture < ActiveRecord::Base

	# VALIDATIONS
	# ============================================================
	validates :artwork, 
		:presence  => true, 
		:file_size => { 
			:maximum => 10.megabytes.to_i 
		}

	# ASSOCIATIONS
	# ============================================================
	belongs_to :work
	mount_uploader :artwork, ArtworkUploader

	# METHODS
	# ============================================================
	def art_src
		artwork.nil? ? '#' : artwork_url
	end

end
