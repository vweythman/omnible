# Curated Methods
# ================================================================================
# methods for controller of curateable models
# 
# Determinations
# --------------------------------------------------------------------------------
#  method name                 | description
# --------------------------------------------------------------------------------
#  character_index             | find models through character
#  concept_index               | find models through concept
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

  # concept_index
  # - find models through concept
  def concept_index
    @parent = Concept.friendly.find(params[:concept_id])
    curated_index
  end

  # identity_index
  # - find models through identity
  def identity_index
    @parent = Identity.find(params[:identity_id])
    curated_index
  end

end