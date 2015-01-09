class Term < ActiveRecord::Base
	belongs_to :facet
	has_many :descriptors
	has_many :characters, :through => :descriptors

	# attribute :name

	# build broader terms
	has_many :broad_edges, foreign_key: :narrow_term_id, class_name: "TermEdge"
	has_many :broad_terms, through: :broad_edges, source: :broad_term

	# build narrower terms
	has_many :narrow_edges, foreign_key: :broad_term_id, class_name: "TermEdge"
	has_many :narrow_terms, through: :narrow_edges, source: :narrow_term

	accepts_nested_attributes_for :broad_edges
	accepts_nested_attributes_for :narrow_edges
end
