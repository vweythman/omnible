class SquadDecorator < Draper::Decorator
	delegate_all

	# GET
	# ============================================================
	# LIST OF INTEGERS
	# ------------------------------------------------------------
	def relator_count
		@relator_count ||= interconnections.group(:relator).count
	end

	# LIST OF MODELS
	# ------------------------------------------------------------
	def connected_people
		@connected_people ||= [] + left_bound_characters + right_bound_characters + characters
	end

	def people
		@people ||= connected_people.uniq!
	end

	def klass
		model.class.to_s
	end

	# LIST OF STRINGS
	# ------------------------------------------------------------
	def current_characters
		@ctags ||= characters.pluck(:name)
	end

	def current_connections
		@conns ||= interconnections.includes(:relator, :left, :right).map(&:data_heading)
	end

	def current_tags
		@tags ||= qualities.pluck(:name)
	end

	# STRINGS
	# ------------------------------------------------------------
	def label_status
		"#{self.label}"
	end

end
