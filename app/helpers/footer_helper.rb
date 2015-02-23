module FooterHelper
	# MODEL FOOTER METHODS
	# -------------------------------------------
	# MAIN FOOTERS
	def anthology_footer(anthology = Anthology.null_state)
		simple_footer(Anthology.null_state, anthology)
	end

	def character_footer(character = Character.null_state)
		simple_footer(Character.null_state, character)
	end

	def concept_footer(concept = Concept.null_state)
		simple_footer(Concept.null_state, concept)
	end

	def identity_footer(identity = Identity.null_state)
		simple_footer(Identity.null_state, identity)
	end

	def relator_footer(relator = Relator.null_state)
		simple_footer(Relator.null_state, relator)
	end

	def work_footer(work = Work.null_state)
		simple_footer(Work.null_state, work)
	end

	# NESTED FOOTERS
	def cast_footer(work, cast = Cast.null_state)
		nested_footer(work, Cast.null_state, cast)
	end

	def chapter_footer(work, chapter = nil)
		nulled  = Chapter.null_state(work)
		chapter = nulled if chapter.nil?
		nested_footer(work, nulled, chapter)
	end

	def note_footer(work, note = nil)
		nulled = Note.null_state(work)
		note   = nulled if note.nil?
		nested_footer(work, nulled, note)
	end

	# FOOTER METHODS
	# -------------------------------------------
	# SIMPLE_FOOTER --- for general model
	def simple_footer(null, entity)
		content_tag :footer do
			concat link_to null.main_title, polymorphic_path(null.part_of)
			concat return_to(entity)
		end
	end

	# NESTED_FOOTER --- for nested model
	def nested_footer(parent_entity, null, entity)
		content_tag :footer do
			concat link_to parent_entity.main_title, polymorphic_path(parent_entity) 
			concat " | " 
			concat link_to null.main_title, polymorphic_path([parent_entity, null.part_of])
			concat return_to entity, [parent_entity, entity]
		end
	end

	# RETURN_TO --- link to model
	def return_to(entity, path_parts = entity)
		if entity.id
			capture do 
				concat " | "
				concat link_to entity.main_title, polymorphic_path(path_parts)
			end
		end
	end
end