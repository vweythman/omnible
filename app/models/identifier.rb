class Identifier < ActiveRecord::Base
  belongs_to :character
  
  def main_title 
  	name
  end
end
