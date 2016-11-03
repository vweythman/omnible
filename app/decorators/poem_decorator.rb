class PoemDecorator < WorkDecorator

	# 1. PUBLIC METHODS
	# ============================================================
	def all_crumbs
		[[h.t('collected.works'), h.works_path], [h.t('content_types.poems'), h.poems_path]]
	end

	def linefied_content
		h.content_tag :div, class: "poem-lines" do
			object.linefy.each do |line|
				h.concat h.markdown line
			end
		end
	end

	def title_for_creation
		"Create Poem"
	end

end
