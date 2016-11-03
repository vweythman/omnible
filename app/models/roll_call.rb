# Picture
# ================================================================================
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable     | type           | about
# --------------------------------------------------------------------------------
#  id           | integer        | unique
#  character_id | integer        | 
#  casting_id   | integer        | 
#  avatar       | string         | 
#  description  | text           | 
#  created_at   | datetime       | must be earlier or equal to updated_at
#  updated_at   | datetime       | must be later or equal to created_at
# ================================================================================

require 'file_size_validator'

class RollCall < ActiveRecord::Base

	# VALIDATIONS
	# ============================================================
	validates :avatar, 
		:presence  => true, 
		:file_size => { 
			:maximum => 2.megabytes.to_i 
		}
	validates :character_id, presence: true

	# ASSOCIATIONS
	# ============================================================
	belongs_to :character
 	belongs_to :casting, class_name: "Work"

 	mount_uploader :avatar, AvatarUploader

	# ATTRIBUTES
	# ============================================================
	attr_accessor :visitor, :title

	def title
		if character_id.nil?
			@title
		else
			character.name
		end
	end

	def visitor
		@visitor ||= nil
	end

	# METHODS
	# ============================================================
	def avatar_src
		avatar.nil? ? '#' : avatar_url
	end

	def relative_position(set_position = Time.now.nsec)
		@relative_position ||= set_position
	end

end
