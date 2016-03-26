class CharacterDecorator < Draper::Decorator

	# DELEGATION
	# ============================================================
	delegate_all

	# MODULES
	# ============================================================
	include CreativeContent
	include CreativeContent::Dossier
	include PageEditing

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	# TEXT
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def creation_title
		"Create Character"
	end

	def icon_choice
		'smile'
	end

	def info_folder
		"subjects/characters/info/"
	end

	def public_opinion_status
		@rep_amt ||= reputations.size

		"Decided by #{@rep_amt} " + "opinion".pluralize(@rep_amt)
	end

	# LISTS
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def connections
		@connections ||= InterconnectionsDecorator.decorate(self.interconnections)
	end

	def current_detail_text
		self.details.build if self.details.length == 0
		@current_details ||= decorated_details
	end

	def filtered_details
		@filtered_details ||= decorated_details.select{|d| d.has_content? }
	end

	def decorated_details
		@decorated_details ||= CharacterInfosDecorator.decorate(self.details)
	end

	def decorated_possessions
		@decorated_possessions ||= PossessionsDecorator.decorate(self.possessions.includes(:item, :generic))
	end

	def identification_list
		@identification_list ||= self.identities.includes(:facet).sorted_alphabetic.decorate
	end

	def public_opinion
		@public_opinion = ViewpointDecorator.decorate average_reputation
	end

	def opinion_scatter_data
		@opinion_scatter_data = [
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

	def relationship_tag_groups
		i = taggables_group(Relator.lacks_reverse.decorate)
		l = taggables_group(Relator.unreversible_lefts.decorate,  :left)
		r = taggables_group(Relator.unreversible_rights.decorate, :right)

		(i.merge l.merge r).sort
	end

	def variant_names
		@variant_names ||= identifiers.pluck(:name)
	end

	def viewpoints
		@viewpoints ||= merge_viewpoints
	end

	# RENDER
	# ------------------------------------------------------------
	# LINKS
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def link_to_next(user = nil)
		nxt = self.next_character(user)
		unless nxt.nil?
			h.link_to "#{nxt.name} &raquo;".html_safe, nxt
		end
	end

	def link_to_prev(user = nil)
		prv = self.prev_character(user)
		unless prv.nil?
			h.link_to "&laquo; #{prv.name}".html_safe, prv
		end
	end

	def link_to_original
		if is_a_clone?
			h.metadata("Based Upon:", h.link_to(original.name, original))
		end
	end

	# BLOCKS
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def alias_headline
		if variant_names.length > 0
			h.content_tag :p, class: 'identifiers' do variant_names.join(", ") end
		end
	end

	def with_descent
		h.content_tag :ul, class: "clones" do
			clones.each do |clone|
				h.concat descent_tree(clone)
			end
		end
	end

	# PARTIALS
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	def clones_panel		
		h.render(info_folder + "clones") unless clones.empty?
	end

	def identity_sidebar
		h.render( :partial => (info_folder+"sidebar"), :locals => { :heading => "Overview", :listable => identification_list }) if identification_list.can_list?
	end

	def personal_opinion_panel
		h.render(info_folder + "personal_opinion") if self.viewpoints.length > 0
	end

	def possessions_cell
		h.render(info_folder + "possessions", possessions: decorated_possessions) if decorated_possessions.can_list?
	end

	def public_opinion_panel
		h.render(info_folder + "public_opinion") if reputations.size > 0
	end

	def subarticle
		h.render(info_folder + "subarticle", details: self.filtered_details)
	end

	def network
		unless self.connections.empty?
			@connections.person = self
			h.render info_folder + "relationships"
		end
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def descent_tree(clone)
		clone = clone.decorate
		link  = h.link_to clone.name, clone
		node  = clone.clones.empty? ? "" : clone.with_descent
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
