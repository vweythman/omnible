class Descriptor < ActiveRecord::Base
	belongs_to :character
	belongs_to :term
end
