class TagDecorator < Draper::Decorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# MODULES
	# ------------------------------------------------------------
	include CreativeContent::Dossier
	include InlineEditing

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- About
	# ............................................................
	def created_at_tag
		h.content_tag :span, class: "time" do
			h.record_time(self.created_at)
		end
	end

	def first_use_status
		h.time_label("First Use") + ": " + created_at_tag
	end

	def content_categories
		@content_categories ||= taggers.map {|u| h.t('content_types.' + u.class.to_s.pluralize.downcase) }
	end

	def categories_count
		@categories_count ||= content_categories.inject(Hash.new(0)) {|count, e| count[e] += 1; count }.sort
	end

	# -- Editor
	# ............................................................
	def editor_heading
		"Edit Tag"
	end

	def edit_bar
		h.alteration_toolkit(self)
	end

end
