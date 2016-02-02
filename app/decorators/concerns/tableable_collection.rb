module TableableCollection

	# RENDER
	# ============================================================
	def tableize
		h.render :partial => table_partial, :locals => { table: table_data }
	end
	
	# SET
	# ============================================================
	def table_partial
		"shared/tableize/#{table_type}"
	end

	def table_data
		self
	end

	def table_type
		:linked
	end

	def caption_heading
		"List"
	end

end