class AnthologyDecorator < Draper::Decorator

	# DELEGATION
	# ============================================================
	delegate_all

	# MODULES
	# ============================================================
	include CreativeContent
	include PageEditing

	# PUBLIC METHODS
	# ============================================================
	# ------------------------------------------------------------
	# DISPLAY CONTENT BLOCKS
	# ------------------------------------------------------------
	def summarized
		summary || ""
	end

	def summary_block
		h.widget_cell(summary_title, class: 'summary-cell') do
			h.concat h.markdown(self.summarized)
		end
	end

	# ------------------------------------------------------------
	# DISPLAY TOOLKIT BLOCKS
	# ------------------------------------------------------------
	def reader_response_bar
		checked_status = h.current_user.tracking? object
		track_path     = checked_status ? h.anthology_untrack_path(object) : h.anthology_track_path(object)

		h.content_tag :div, class: "toolkit reader-response" do
			h.link_to_track(track_path, checked_status)
		end
	end

	# ------------------------------------------------------------
	# SELECT TEXT
	# ------------------------------------------------------------
	def klass
		:anthology
	end

	def summary_title
		h.t("work.summary_title")
	end

	# ------------------------------------------------------------
	# SELECT WORKS
	# ------------------------------------------------------------
	def current_works
		@current_works ||= Collectables::CollectionsDecorator.decorate(self.works)
	end

	def possible_works
		@possible_works ||= h.current_user.onsite_works.alphabetical
	end

end
