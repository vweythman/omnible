class StoryDecorator < WorkDecorator

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- About
	# ............................................................
	def creation_title
		"Create Story"
	end

	def link_to_whole_story
		h.link_to "Whole Story", h.whole_story_path(self)
	end

	def link_to_chaptered_view
		h.link_to "First Chapter", h.story_path(self)
	end

	def createables
		if self.editable?(h.current_user)
			h.prechecked_createables [[self, :chapter], [self, :note]]
		end
	end

	def klass
		@klass ||= :story
	end

	def title_with_count
		len = self.taggable_chapter_count
		title + " (" + len.to_s + " " + "Chapter".pluralize(len) + ")"
	end

	# -- Chapters
	# ............................................................
	def link_to_chapters
		h.link_to "Chapters", h.story_chapters_path(self)
	end

	def chapter_creation_link
		if self.editable?(h.current_user)
			h.prechecked_creation_toolkit("Chapter", [self, :chapter])
		end
	end

	def chapter_insertion_link
		if self.editable?(h.current_user)
			h.insertion_toolkit("Chapter", [self, :chapter])
		end
	end

	def chapters_count_status
		h.content_tag :p, class: "chapters-count" do 
			"Chapters: " + self.chapters.length.to_s
		end
	end

	def chapters_status
		text = link_first_chapter

		if self.taggable_chapter_count > 1
			text += link_latest_chapter
		end

		h.content_tag :p, class: "chapters" do 
			text
		end
	end

	def current_chapters
		self.chapters.build if self.chapters.length == 0
		@current_chapters ||= Collectables::Works::ChaptersDecorator.decorate(self.chapters)
	end

	def link_first_chapter
		i = searchable_metadata["first-chapter"]
		h.link_to "First", h.story_chapter_path(self.id, i) unless i.nil?
	end

	def link_latest_chapter
		i = searchable_metadata["latest-chapter"]
		h.link_to "Latest", h.story_chapter_path(self.id, i)
	end

	# -- Navigation
	# ............................................................
	def all_crumbs
		[[h.t('collected.works'), h.works_path], [h.t('collected.fiction'), h.fiction_index_path], [h.t('content_types.stories'), h.stories_path]]
	end

	def directory_scenes
		scenes = [["Whole Story", h.whole_story_path(self)], ["Chapters", h.story_chapters_path(self)], ["First Chapter", h.story_path(self)]]
		scenes << ["Notes", h.story_notes_path(self)]
		scenes
	end

end
