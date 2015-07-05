# Curated Methods
# ================================================================================
# methods for controller of curateable models
# 
# Determinations
# --------------------------------------------------------------------------------
#  method name                 | description
# --------------------------------------------------------------------------------
#  character_index             | find models through character
#  tag_index                   | find models through tag
#  identity_index              | find models through identity
# ================================================================================

module Curated

  # DETERMINATIONS
  # ------------------------------------------------------------
  # character_index
  # - find models through character
  def character_index
    @parent = Character.find(params[:character_id])
    curated_index
  end

  # tag_index
  # - find models through tag
  def tag_index
    @parent = Tag.friendly.find(params[:tag_id])
    curated_index
  end

  # identity_index
  # - find models through identity
  def identity_index
    @parent = Identity.find(params[:identity_id])
    curated_index
  end

end