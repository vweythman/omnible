# Challenge
# ================================================================================
# interactive work prompt and creation
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  title           | string      | maximum of 250 characters
#  uploader_id     | integer     | references user
#  about           | string      | can be null
#  response_level  | string      | who can respond
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
# ================================================================================

class Challenge < ActiveRecord::Base
	
	UNPUBLISHED  = 'undecided'
	FRIENDS_ONLY = 'friends only'
	FRIENDS_N_FOLLOWERS = 'friends and followers'
	EXCEPT_BLOCKED      = 'any user except blocked users'
	ANYONE              = 'anyone'

  belongs_to :uploader
end
