module Collectables
	class SubjectsDecorator < Draper::CollectionDecorator

		# MODULES
		# ------------------------------------------------------------
		include ListableCollection
		include Widgets::ListableResults

		# PUBLIC METHODS
		# ------------------------------------------------------------
		def title
			"Subjects"
		end
		
		def heading
			"Subjects"
		end

		def creation_path
			h.multi_kit types.map {|k| k.to_s.singularize }
		end

		# PRIVATE METHODS
		# ------------------------------------------------------------
		private

		def listable
			self.sort_by! { |x| x[:name].downcase }
		end

		def types
			[:characters, :items, :places]
		end

	end
end
