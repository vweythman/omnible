class CastingDecorator < WorkDecorator
	
	# PUBLIC METHODS
	# ============================================================
	def all_crumbs
		[[h.t('collected.works'), h.works_path], [h.t('collected.nonfiction'), h.nonfiction_index_path], [h.t('content_types.castings'), h.castings_path]]
	end

end
