class PoemDecorator < WorkDecorator
	
	# PUBLIC METHODS
	# ============================================================
	def klass
		@klass ||= :poem
	end

	def icon_choice
		'image'
	end

	def title_for_creation
		"Create Poem"
	end

	def linefied_content
		h.content_tag :div, class: "poem-lines" do
			object.linefy.each do |line|
				h.concat h.markdown line
			end
		end
	end

	def breadcrumbs
		crumbs = [[h.t('collected.works'), h.works_path], [h.t('content_types.poems'), h.poems_path]]
		breacrumbing(crumbs)
	end

end
