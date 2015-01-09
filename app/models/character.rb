class Character < ActiveRecord::Base
	has_many :descriptors
	has_many :terms, :through => :descriptors
end
