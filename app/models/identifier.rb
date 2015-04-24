class Identifier < ActiveRecord::Base

  # ASSOCIATIONS
  # ------------------------------------------------------------
  belongs_to :character
  
  # METHODS
  # ------------------------------------------------------------
  # Heading
  # - defines the main means of addressing the model
  def heading 
  	name
  end

end
