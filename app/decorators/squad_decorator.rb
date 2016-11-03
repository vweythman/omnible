class SquadDecorator < Draper::Decorator

	# DELEGATION
	# ============================================================
	delegate_all

	# MODULES
	# ============================================================
	include CreativeContent
	include CreativeContent::Dossier
	include PageEditing

	# TABLE of METHOD CONTENTS
	# ============================================================
	# PUBLIC METHODS
	# -- SELECT NUMBER
	# ----- relator_count
	#
	# -- SELECT TAGS
	# ----- connected_people - all characters by tag or tagged relationships
	# ----- people
	#
	# -- SELECT TEXT
	# ----- current_characters  - names of tagged characters
	# ----- current_connections - names of tagged relationshps
	# ----- current_tags        - names of current general tags
	# ----- label_status        - type of squad
	#
	# ============================================================
	# ------------------------------------------------------------
	# SELECT NUMBER
	# ------------------------------------------------------------
	def relator_count
		@relator_count ||= interconnections.group(:relator).count
	end

	# ------------------------------------------------------------
	# SELECT TAGS
	# ------------------------------------------------------------
	# ............................................................
	# connected_people - all characters by tag or tagged
	# relationships
	# ............................................................
	def connected_people
		@connected_people ||= [] + left_bound_characters + right_bound_characters + characters
	end

	def people
		@people ||= connected_people.uniq!
	end

	# ------------------------------------------------------------
	# SELECT TEXT
	# ------------------------------------------------------------
	# ............................................................
	# current_characters - names of tagged characters
	# ............................................................
	def current_characters
		@ctags ||= characters.pluck(:name)
	end

	# ............................................................
	# current_connections - names of tagged relationshps
	# ............................................................
	def current_connections
		@conns ||= interconnections.includes(:relator, :left, :right).map(&:data_heading)
	end

	# ............................................................
	# current_tags - names of current general tags
	# ............................................................
	def current_tags
		@tags ||= qualities.pluck(:name)
	end

	# ............................................................
	# label_status - type of squad
	# ............................................................
	def label_status
		"#{self.label}"
	end
	# ============================================================

end
