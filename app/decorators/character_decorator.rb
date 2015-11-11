class CharacterDecorator < EditableDecorator
	delegate_all

	# HEADINGS
	# ------------------------------------------------------------
	def heading
		name
	end

	def creation_title
		"Create Character"
	end

	def editing_title
		name + " (Unsaved Draft)"
	end

	def link_to_original
		if is_a_clone?
			h.content_tag :p, class: 'announce' do
				"Based Upon: #{h.link_to(original.name, original)}".html_safe
			end
		end
	end

	# ABOUT
	# ------------------------------------------------------------
	def list_aliases
		if identifiers.size > 0
			h.content_tag :p, class: 'identifiers' do identifiers.pluck(:name).join(", ") end
		end
	end

	def variant_names
		identifiers.pluck(:name).join("; ")
	end

	def viewpoints
		if @viewpoints.nil?
			prejudices  = self.prejudices.includes(:identity).decorate
			opinions    = self.opinions.includes(:recip).decorate
			@viewpoints = prejudices + opinions
		end
		return @viewpoints
	end

	def connections
		@connections ||= InterconnectionsDecorator.decorate(self.interconnections)
	end

	def clone_list
		h.content_tag :ul, class: "clones" do
			clones.each do |clone|
				h.concat descent_tree(clone)
			end
		end
	end

	def descent_tree(clone)
		clone = clone.decorate
		link  = h.link_to clone.name, clone
		node  = clone.clones.empty? ? "" : clone.clone_list
		h.content_tag :li do
			link + node
		end
	end

	# OPINIONS
	# ------------------------------------------------------------
	def public_opinion_status
		@rep_amt ||= reputations.size

		"Decided by #{@rep_amt} " + "opinion".pluralize(@rep_amt)
	end

	def public_opinion
		opinion = ViewpointDecorator.decorate average_reputation
	end

	def opinion_scatter_data
		data = [
			{
				label: "Opinions",
				strokeColor: "#559933",
				data: opinions.uniques.map{|p| {x: p.fondness, y: p.respect, r: p.count} }
			},
			{
				label: "Reputations",
				strokeColor: "#4095BF",
				data: reputations.uniques.map{|p| {x: p.fondness, y: p.respect, r: p.count} }
			}
		]
	end

	# ASIDE
	# ------------------------------------------------------------
	def list_possessions
		possessions = PossessionsDecorator.decorate(self.possessions.includes(:item, :generic))
		possessions.items.html_safe
	end

	def list_identities
		identities = self.identities.alphabetic.includes(:facet).decorate
		if identities.can_list?
			h.subgrouped_list("Overview", identities)
		end
	end

	# RELATED MODELS
	# ------------------------------------------------------------
	def pagination(user = nil)
		prv = h.content_tag :li, class: 'prev'    do link_to_prev end
		slf = h.content_tag :li, class: 'current' do self.name end
		nxt = h.content_tag :li, class: 'next'    do link_to_next end
		h.content_tag :ol, class: 'pagination' do
			prv + slf + nxt 
		end
	end

	def link_to_prev(user = nil)
		prv = self.prev_character(user)
		unless prv.nil?
			h.link_to "&laquo; #{prv.name}".html_safe, prv
		end
	end

	def link_to_next(user = nil)
		nxt = self.next_character(user)
		unless nxt.nil?
			h.link_to "#{nxt.name} &raquo;".html_safe, nxt
		end
	end

	def replication_bar
		dup = h.link_to "Duplicate", h.replicate_path(self), method: :post
		con = h.link_to("Connect to Original Variant", h.edit_clone_path(self))
		rol = h.content_tag :a do "Create a Roleplay Copy" end

		links = self.is_a_clone? ? (dup + rol) : (con + dup + rol)

		h.content_tag :nav, class: 'toolkit replication' do
			links
		end
	end

	def current_detail_text
		self.details.build if self.details.length == 0
		@current_details ||= decorated_details
	end

	def decorated_details
		CharacterInfosDecorator.decorate(self.details)
	end

end
