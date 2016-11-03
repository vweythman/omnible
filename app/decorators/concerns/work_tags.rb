# WorkFields
# ============================================================
# TABLE of CONTENTS
# ============================================================
# PUBLIC METHODS
# -- DISPLAY CONTENT BLOCKS
# ----- all_tags_line
# ----- snippet_tags_line
# ----- tag_block
#
# -- SELECT SUBSECTION OF TAGS
# ----- important_characters
# ----- main_tags
#
# -- SELECT SORTED TAG GROUPS
# ----- ordered_characters
# ----- ordered_characters_for_snippets
# ----- ordered_squads
# ----- ordered_true_tags
# ----- ordered_works
#
# PRIVATE METHODS
# ----- order_tags
# ----- tag_heading
#
# ============================================================

module WorkTags

	# PUBLIC METHODS
	# ============================================================
	# ------------------------------------------------------------
	# DISPLAY CONTENT BLOCKS
	# ------------------------------------------------------------
	def all_tags_line
		h.tag_group all_tags, 'works', { class: 'all-tags tags' }, { class: 'tag' }
	end

	def snippet_tags_line
		if main_tags.length > 0
			h.tag_group main_tags, 'works', { class: 'main-tags tags' }, { class: 'tag' }
		end
	end

	def tag_block(tags, heading, block_options = {}, tag_options = {})
		if tags.length > 0
			h.content_tag :div, class: "tags" do 
				h.concat tag_heading(heading)
				h.concat h.tag_group tags, 'works', block_options, tag_options
			end
		end
	end

	# ------------------------------------------------------------
	# DISPLAY TAG BLOCKS
	# ------------------------------------------------------------
	def places_tag_block
		tag_block places, "Places", { class: "places" }, { class: h.tag_label_by("place") }
	end

	# ------------------------------------------------------------
	# SELECT SUBSECTION OF TAGS
	# ------------------------------------------------------------
	def important_characters
		@important_characters ||= work.narrative? ? Array(ordered_characters_for_snippets.group_by("main")) : Array(ordered_characters_for_snippets.group_by("subject"))
	end

	def main_tags
		@main_tags ||= (self.tags + self.important_characters + self.places).sort_by! { |x| x[:name].downcase }
	end

	# ------------------------------------------------------------
	# SELECT SORTED TAG GROUPS
	# ------------------------------------------------------------
	def ordered_characters
		@ordered_characters ||= order_tags Appearance.organize(self.appearances.with_character)
	end

	def ordered_characters_for_snippets
		@ordered_characters ||= order_tags Appearance.organize(self.appearances)
	end

	def ordered_squads
		@social_cohorts     ||= order_tags SocialAppearance.organize(self.social_appearances.with_squad)
	end

	def ordered_true_tags
		@ordered_true_tags  ||= order_tags Tagging.organize(self.taggings.with_tag)
	end

	def ordered_works
		@ordered_works      ||= order_tags WorkConnection.organize(self.intratagged.with_tagged)
	end

	# ============================================================
	# PRIVATE METHODS
	# ============================================================
	private

	def order_tags(tags)
		OrganizedTagGroups.new tags
	end

	def tag_heading(heading)
		h.content_tag :h3 do
			heading
		end
	end

end
