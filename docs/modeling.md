Models
=========================================================================
- Facet
	- has_many facets
- Term
	- belongs_to facet
- Opinion
	- belongs_to holder (Person)
	- belongs_to recip  (Person or Group)
- Character
	- has_many descriptions
	- has_many descriptors, through descriptions

characters
	string name
	text about

facet
	string name

term
	string name
	belongs_to facet

term_relationships
	belongs_to bt (term)
	belongs_to nt (term)

descriptions
	belongs_to :character
	belongs_to :term
	string type

opinions
	belongs_to holder (term)
	belongs_to recip (polymorphic)
	integer warmth
	integer respect 
	text summary

relator
	u



