class User < ActiveRecord::Base
	has_many :works
	validates :name, presence: true
	validates :email, presence: true
end
