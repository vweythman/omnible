# Membership
# ================================================================================
# join table
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  work_id         | integer     | references character
#  social_group_id | integer     | references group
#  form            | string      | type column
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
# ================================================================================

class SocialAppearance < ActiveRecord::Base

	# MODULES
	# ============================================================
	extend Organizable
	include CountableTagging

	# SCOPES
	# ============================================================
	# SUBTYPES
	# ------------------------------------------------------------
	scope :anti_ship, -> { where(form: "anti ship") }
	scope :main_ship, -> { where(form: "main ship") }
	scope :side_ship, -> { where(form: "side ship") }
	scope :social,    -> { where(form: "social group") }

	# SELECT
	# ------------------------------------------------------------
	scope :tagger_by_squads,         ->(ws)      { tagger_by_tag_names(ws, :work_id, :social_group) }
	scope :tagger_by_grouped_squads, ->(nat, ws) { where(form: nat).tagger_by_squads(ws) }

	scope :with_squad, -> { includes(:social_group) }

	# CLASS METHODS
	# ============================================================
	def self.labels
		['main ship', 'side ship', 'anti ship', 'group']
	end

	def self.data_labels
		[:main_ship, :side_ship, :anti_ship, :social_group]
	end

	def self.tag_labels(work)
		work.narrative? ? narrative_labels : subject_labels
	end

	def self.subject_labels
		{
			main_ship:    'Subject (Ship)', 
			anti_ship:    'Subject (Anti Ship)', 
			social_group: 'Subject (Group)'
		}
	end

	def self.narrative_labels
		{
			main_ship:    'Main Ship Tags', 
			side_ship:    'Side Ship Tags', 
			anti_ship:    'Anti Ship Tags', 
			social_group: 'Group tags'
		}
	end

	# ASSOCIATIONS
	# ============================================================
	# BELONGS TO
	# ------------------------------------------------------------
	belongs_to :social_group, class_name: "Squad"
	belongs_to :work

	# SUBTYPES
	# ------------------------------------------------------------
	belongs_to :social_tag,     -> { SocialAppearance.social    }, class_name: "Squad", foreign_key: "social_group_id"
	belongs_to :ship_tag,       -> { SocialAppearance.main_ship }, class_name: "Squad", foreign_key: "social_group_id"

	belongs_to :anti_ship_tag,  -> { SocialAppearance.anti_ship }, class_name: "Squad", foreign_key: "social_group_id"
	belongs_to :side_ship_tag,  -> { SocialAppearance.side_ship }, class_name: "Squad", foreign_key: "social_group_id"

	# CLASS METHODS
	# ============================================================
	def self.tagger_intersection_sql(finds)
		if (finds.keys - self.labels).empty?
			finds.map {|k, titles| SocialAppearance.tagger_by_grouped_squads(k.to_s, titles.split(";")).to_sql }.join(" INTERSECT ")
		else
			""
		end
	end

	# PUBLIC METHODS
	# ============================================================
	def nature
		self.form
	end

	def linkable
		self.social_group
	end

end
