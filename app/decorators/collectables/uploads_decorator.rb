module Collectables
	class UploadsDecorator < Draper::CollectionDecorator

		def content_categories
			@content_categories ||= self.map {|u| h.t('content_types.' + u.content_category) }
		end

		def categories_count
			@categories_count ||= content_categories.inject(Hash.new(0)) {|count, e| count[e] += 1; count }.sort
		end

		def is_mixture?
			categories_count.length > 1
		end

		def subtitles
			subtitles = [h.t("user.uploads")]
			subtitles << content_categories.first unless is_mixture?
			subtitles
		end

	end
end
