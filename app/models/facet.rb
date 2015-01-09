class Facet < ActiveRecord::Base
	validates :name, uniqueness: { case_sensitive: false }
	has_many  :terms
end
