module IndexHelper

	# CURATION
	# ============================================================
	def curated_works_url_appender(parent, filter)
		url_for(parent) + '/works/?' + filter.to_query
	end

	# FILTERS
	# ============================================================
	def link_to_filter(label, type, key)
		link_to label, params.merge(type => key)
	end

end
