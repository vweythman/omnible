module CreativeContent
	module Dossier

		# GET
		# ============================================================
		def heading_id
			klass + "-" + object.id.to_s
		end

		def klass
			@klass ||= self.object.class.to_s.downcase
		end

		# SET
		# ============================================================
		def title_for_creation
			@meta_title ||= "Create " + klass.titleize
		end

		def title_for_editing
			@meta_title ||= heading + "*"
		end

		# RENDER
		# ============================================================
		def shared_footer
			h.render 'subjects/shared/footer'
		end

	end
end