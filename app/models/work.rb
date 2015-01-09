class Work < ActiveRecord::Base
	belongs_to :user
	validates :title, length: { maximum: 250 }, presence: true
end
