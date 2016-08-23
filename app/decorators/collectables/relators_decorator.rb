module Collectables
	class RelatorsDecorator < Draper::CollectionDecorator

		# MODULES
		# ------------------------------------------------------------
		include ListableCollection
		include Widgets::ListableResults

		# PUBLIC METHODS
		# -----------------------------------------------------------
		def creation_path
			if h.user_signed_in? && h.current_user.staffer?
				h.inline_creation_toolkit "Relationship", :relator
			end
		end

		def inline_creation
			h.form_div_for_ajaxed_creation "relationship"
		end

		def index_heading
			"Relationship Tags"
		end

		def klass
			@klass ||= :relators
		end

		def taggables_list_for(person, direction = nil)
			set = person.relation_set(false)
			pnm = [person.name]
			h   = Hash.new
			self.each do |r|

				l = set.minor_keys(r.id)
				c = l.map {|k| set.end_values(r.id, k) }.flatten

				if direction.nil?
					t = r.left_name
					i = (l + c).uniq - pnm
				elsif direction == :left
					t = r.left_name
					i = l.uniq - pnm
				else
					t = r.right_name
					i = c.uniq - pnm
				end

				h[t] = { :id => r.formid, :list => i }
			end
			return h
		end

		# PRIVATE METHODS
		# -----------------------------------------------------------
		private

		def list_type
			:links
		end

		def results_content_type
			:titled_cell
		end

	end
end
