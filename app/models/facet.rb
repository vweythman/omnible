class Facet < ActiveRecord::Base
	extend FriendlyId
	default_scope {order('name')}
	has_many :identities
  	friendly_id :name
end
