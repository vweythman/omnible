class CharacterDecorator < Draper::Decorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# MODULES
	# ------------------------------------------------------------
	include CreativeContent
	include CreativeContent::Dossier
	include PageEditing

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- About
	# ............................................................
	def link_to_original
		if is_a_clone?
			h.content_tag :p, class: 'announce' do
				"Based Upon: #{h.link_to(original.name, original)}".html_safe
			end
		end
	end

	def variant_names
		identifiers.pluck(:name)
	end

	# -- Creating & Editing
	# ............................................................
	def creation_title
		"Create Character"
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

	# -- Lists
	# ............................................................
	def list_aliases
		if identifiers.size > 0
			h.content_tag :p, class: 'identifiers' do identifiers.pluck(:name).join(", ") end
		end
	end

	def list_identities
		identities = self.identities.sorted_alphabetic.decorate
		if identities.can_list?
			h.subgrouped_list("Overview", identities)
		end
	end

	def list_clones
		h.content_tag :ul, class: "clones" do
			clones.each do |clone|
				h.concat descent_tree(clone)
			end
		end
	end

	def list_possessions
		possessions = PossessionsDecorator.decorate(self.possessions.includes(:item, :generic))
		possessions.items.html_safe
	end

	def subarticle
		self.decorated_details.subarticle
	end

	def table_connections
		self.connections.faceted_table(self) unless self.connections.empty?
	end

	# -- Pagination
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

	# -- Status
	# ............................................................
	def public_opinion_status
		@rep_amt ||= reputations.size

		"Decided by #{@rep_amt} " + "opinion".pluralize(@rep_amt)
	end

	# -- Related
	# ............................................................
	def connections
		@connections ||= InterconnectionsDecorator.decorate(self.interconnections)
	end

	def current_detail_text
		self.details.build if self.details.length == 0
		@current_details ||= decorated_details
	end

	def decorated_details
		CharacterInfosDecorator.decorate(self.details)
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

	def public_opinion
		opinion = ViewpointDecorator.decorate average_reputation
	end

	def relationship_tag_groups
		i = taggables_group(Relator.lacks_reverse.decorate)
		l = taggables_group(Relator.unreversible_lefts.decorate,  :left)
		r = taggables_group(Relator.unreversible_rights.decorate, :right)

		(i.merge l.merge r).sort
	end

	def viewpoints
		@viewpoints ||= merge_viewpoints
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	def descent_tree(clone)
		clone = clone.decorate
		link  = h.link_to clone.name, clone
		node  = clone.clones.empty? ? "" : clone.list_clones
		h.content_tag :li do
			link + node
		end
	end

	def taggables_group(rgroup, direction = nil)
		rgroup.taggables_list_for(self, direction)
	end

	def merge_viewpoints
		prejudices  = self.prejudices.includes(:identity).decorate
		opinions    = self.opinions.includes(:recip).decorate
		prejudices + opinions
	end

end
