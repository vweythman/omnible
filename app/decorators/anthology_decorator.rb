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
	def possible
		@possible_works ||= Work.order('lower(title)').decorate
	end

	def current_works
		@current_works ||= Collectables::CollectionsDecorator.decorate(self.works)
	end

	def response_bar
		if self.uploader? h.current_user
			edit_bar
		elsif h.current_user.present?
			reader_response_bar
		end
	end

	def summary_block
		h.widget_cell(summary_title, class: 'summary-cell') do
			h.concat h.markdown(self.summarized)
		end
	end

	def summary_title
		h.t("work.summary_title")
	end

	def summarized
		summary || ""
	end

	def reader_response_bar
		checked_status = h.current_user.tracking? object
		track_path     = checked_status ? h.anthology_untrack_path(object) : h.anthology_track_path(object)

		h.content_tag :div, class: "toolkit reader-response" do
			h.link_to_track(track_path, checked_status)
		end
	end

	def icon_choice
		'stack'
	end

	def klass
		:anthology
	end

end
