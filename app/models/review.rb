# Review
# ================================================================================
# reviews are part of the rateable group
# ================================================================================

class Review < ActiveRecord::Base

  # ASSOCIATIONS
  # ------------------------------------------------------------
  belongs_to :work
  belongs_to :user

end
