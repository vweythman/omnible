class TermEdge < ActiveRecord::Base
	belongs_to :broad_term,  foreign_key: "broad_term_id",  class_name: "Term"
	belongs_to :narrow_term, foreign_key: "narrow_term_id", class_name: "Term"
end
