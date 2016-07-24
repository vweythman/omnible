require 'active_support/concern'

module Recordable
	extend ActiveSupport::Concern

	# INCLUSION
	# ============================================================
	included do

		# CALLBACKS
		# ------------------------------------------------------------
		after_save :update_creators, on: [:update, :create]

		# SCOPES
		# ------------------------------------------------------------
		scope :seek_with_creator, ->(creator_name) { joins(:creators).where("characters.name IN (?)", creator_name) }
		scope :seek_with_type,    ->(type_name)    { joins('LEFT OUTER JOIN "record_metadata" ON "record_metadata"."work_id" = "works"."id"').where("((key = 'medium' AND value = ?) OR type = ?)", type_name, type_name.split(' ').collect(&:capitalize).join) }

		# CATEGORIES
		# ------------------------------------------------------------
		scope :fiction,    -> { where("type IN (#{WorksTypeDescriber.fiction.select(:name).to_sql})")    }
		scope :nonfiction, -> { where("type IN (#{WorksTypeDescriber.nonfiction.select(:name).to_sql})") }

		scope :chaptered,  -> { where("type IN (#{WorksTypeDescriber.chaptered.select(:name).to_sql})") }
		scope :oneshot,    -> { where("type IN (#{WorksTypeDescriber.oneshot.select(:name).to_sql})")   }
		
		scope :complete,   -> { where(status: 'complete')   }
		scope :incomplete, -> { where(status: 'incomplete') }

		scope :onsite,     -> { where("type IN (#{WorksTypeDescriber.onsite.select(:name).to_sql})") }
		scope :offsite,    -> { where("type IN (#{WorksTypeDescriber.offsite_sql})")   }

		scope :textual,     -> { where("type IN (#{WorksTypeDescriber.textual.select(:name).to_sql})")     }
		scope :audible,     -> { where("type IN (#{WorksTypeDescriber.audible.select(:name).to_sql})")     }
		scope :audiovisual, -> { where("type IN (#{WorksTypeDescriber.audiovisual.select(:name).to_sql})") }
		scope :visual,      -> { where("type IN (#{WorksTypeDescriber.visual.select(:name).to_sql})")      }
		scope :evidential,  -> { where("type IN (#{WorksTypeDescriber.evidential.select(:name).to_sql})")  }
		scope :nondata,     -> { where.not(type: "Record") }

		# ASSOCIATIONS
		# ------------------------------------------------------------
		# Joins
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		has_many :creatorships, dependent: :destroy

		# Has and Belongs To
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		has_many   :creators,       through: :creatorships
		belongs_to :type_describer, class_name: "WorksTypeDescriber",          foreign_key: "type",    primary_key: "name"
		has_many   :qualitatives,   class_name: "RecordMetadatum",             foreign_key: "work_id", dependent: :destroy, extend: DataDrivenExtension
		has_many   :quantitatives,  class_name: "RecordQuantitativeMetadatum", foreign_key: "work_id", dependent: :destroy, extend: DataDrivenExtension

		# References
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		has_many   :creator_categories, through: :type_describer

	end

	# ATTRIBUTES
	# ============================================================
	attr_accessor :visitor, :uploadership
	def uploadership
		@uploadership ||= { :category => nil, :pen_name => nil }
	end
	def visitor
		@visitor      ||= nil
	end

	# CLASS METHODS
	# ============================================================
	class_methods do

		def toggle_links(show_links)
			if show_links
				nondata
			else
				onsite
			end
		end

		# OrderBy :: filter by sort
		def order_by(choice)
			case choice
			when "alphabetical"
				alphabetical
			when "chronological"
				chronological
			when "chapter-count"
				by_chapters
			else
				updated
			end
		end

		# ContextualizeBy :: filter by content type
		def contextualize_by(content_type)
			if ["text", "data", "audio", "picture", "video", "reference"].include? content_type
				where("type IN (#{WorksTypeDescriber.by_content(content_type).select(:name).to_sql})")
			else
				all
			end
		end

		# Ready :: filter by completion
		def ready(seeking_completion)
			case seeking_completion
			when "yes"
				complete
			when "no"
				incomplete
			else
				all
			end
		end

		# Span :: filter by time
		def span(choice)
			case choice
			when "thisyear"
				within_year
			when "thismonth"
				within_month
			when "today"
				within_day
			else
				all
			end
		end

		# WithRating :: filter by rating
		def with_rating(rate_options)
			unless rate_options.nil? || rate_options.length < 1
				joins(:rating).merge(Rating.choose(rate_options))
			else
				all
			end
		end

		def within_rating(rate_options)
			unless rate_options.nil? || rate_options.length < 1
				joins(:rating).merge(Rating.within_range(rate_options))
			else
				all
			end
		end

	end

	# PUBLIC METHODS
	# ============================================================
	# GETTERS
	# ------------------------------------------------------------
	def searchable_qualitative_metadata
		@searchable_qualitative_metadata ||= Hash[self.qualitatives.map{|m| [m.key, m.value]}]
	end

	def searchable_quantitative_metadata
		@searchable_quantitatives_metadata ||= Hash[self.quantitatives.map{|m| [m.key, m.value]}]
	end

	def searchable_metadata
		@searchable_metadata ||= searchable_qualitative_metadata.merge searchable_quantitative_metadata
	end

	# ACTIONS
	# ------------------------------------------------------------
	def creatorize(catid, nameid)
		Creatorship.create(creator_category_id: catid, creator_id: nameid, work_id: self.id)
	end

	def editor_creatorize(catid, nameid, editor)
		editor_pen = self.creatorships.are_among_for(editor.all_pens.pluck(:id)).first

		if editor_pen.nil?
			creatorize(catid, nameid)
		elsif nameid != editor_pen.id
			editor_pen.update(creator_category_id: catid, creator_id: nameid)
		end
	end

	def update_metadata
	end

	# PRIVATE METHODS
	# ============================================================
	private
	def update_creators
		up_cat_id = uploadership[:category]
		up_nam_id = uploadership[:pen_name]

		unless up_cat_id.nil?
			editor_creatorize(up_cat_id, up_nam_id, visitor)
		end
	end

end
