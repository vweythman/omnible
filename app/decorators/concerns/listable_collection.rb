module ListableCollection

	# OUTPUT
	# ------------------------------------------------------------
	def list
		h.render :partial => list_partial, :locals => { listable: listable }
	end

	def filters
		h.render partial: filters_partial
	end

	def results
		h.render :partial => results_partial, :locals => { results: self }
	end

	def found_status
		h.content_tag :p, class: "found" do self.total_count.to_s + " Found" end
	end

	def index_content
		h.render :partial => "shared/results/#{results_content_type}", :locals => { results: self }
	end

	def simple_results
		h.render :partial => "shared/results/default_panel", :locals => { results: self }
	end
	
	# PARTIAL LOCATIONS
	# ------------------------------------------------------------
	def list_partial
		"shared/lists/#{list_type}"
	end

	def results_partial
		"shared/results/#{results_type}"
	end

	def filters_partial
		"filters"
	end

	# DEFAULTS
	# ------------------------------------------------------------
	def listable
		self
	end

	def list_type
		:unordered_list
	end

	def page_window
		2
	end

	def results_content_type
		:simple_cell
	end

	def results_type
		:simple_panel
	end

end
