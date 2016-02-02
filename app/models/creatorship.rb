class Creatorship < ActiveRecord::Base

	scope :are_among_for, ->(cids) { where("creator_id IN (?)", cids)}

	belongs_to :category, class_name: "CreatorCategory", inverse_of: :creatorships, foreign_key: "creator_category_id"
	belongs_to :creator,  class_name: "Character"
	belongs_to :work

	belongs_to :pseudonyming, primary_key: "character_id", foreign_key: "creator_id"
	has_one    :psuedonymer,  through: :pseudonyming, source: :user

end
