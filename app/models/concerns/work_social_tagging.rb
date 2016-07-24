require 'active_support/concern'

module WorkSocialTagging
	extend ActiveSupport::Concern

	# INCLUSION
	# ============================================================
	included do

		# CALLBACKS
		# ------------------------------------------------------------
		before_validation :build_socials, on: [:update, :create]

		# ASSOCIATIONS
		# ------------------------------------------------------------
		# JOINS
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		# Unsorted Tags
		has_many :social_appearances, dependent: :destroy

		# Sorted Tags
		has_many :anti_relationshippings,  -> { SocialAppearance.anti_ship }, class_name: "SocialAppearance"
		has_many :group_relationshippings, -> { SocialAppearance.social    }, class_name: "SocialAppearance"
		has_many :ship_relationshippings,  -> { SocialAppearance.main_ship }, class_name: "SocialAppearance"
		has_many :side_relationshippings,  -> { SocialAppearance.side_ship }, class_name: "SocialAppearance"

		# HAS
		# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		# Unsorted Tags
		has_many :social_groups, ->{uniq}, through: :social_appearances

		# Sorted Tags
		has_many :anti_ship_tags, through: :anti_relationshippings
		has_many :social_tags,    through: :group_relationshippings
		has_many :ship_tags,      through: :ship_relationshippings
		has_many :side_ship_tags, through: :side_relationshippings

	end

	# ATTRIBUTES
	# ============================================================
	attr_accessor :visitor, :socialables
	def socialables
		@socialables ||= { :main_ship => nil, :side_ship => nil, :anti_ship => nil, :social_group => nil }
	end
	def visitor
		@visitor     ||= nil
	end

	# CLASS METHODS
	# ============================================================
	class_methods do

		def filter_by_squads(withs, withouts)
			with_squads(withs).without_squads(withouts)
		end

		def with_squads(taggings)
			if (taggings.is_a? Hash)
				with_ordered_squads(taggings)
			elsif (taggings.is_a? String)
				with_unordered_squads(taggings.split(";"))
			else
				all
			end
		end

		def without_squads(taggings)
			if (taggings.is_a? Hash)
				without_ordered_squads(taggings)
			elsif (taggings.is_a? String)
				without_unordered_squads(taggings.split(";"))	
			else
				all
			end		
		end

		private
		# ORDERED
		def with_ordered_squads(taggings)
			where("works.id IN (#{SocialAppearance.tagger_intersection_sql(taggings)})")
		end

		def without_ordered_squads(taggings)
			where("works.id NOT IN (#{SocialAppearance.tagger_intersection_sql(taggings)})")
		end

		# UNSORTED
		def with_unordered_squads(titles)
			where("works.id IN (#{SocialAppearance.tagger_by_squads(titles).to_sql})")
		end

		def without_unordered_squads(titles)
			where("works.id NOT IN (#{SocialAppearance.tagger_by_squads(titles).to_sql})")
		end

	end

	# PRIVATE METHODS
	# ============================================================
	private

	def build_socials
		updated_social_tags self.ship_tags,      socialables[:main_ship]
		updated_social_tags self.side_ship_tags, socialables[:side_ship]
		updated_social_tags self.anti_ship_tags, socialables[:anti_ship]
		updated_social_tags self.social_tags,    socialables[:social_group]
	end

	def organize_social_tags(old_tags, new_tags)
		old_tags.delete(old_tags - new_tags)
		old_tags <<    (new_tags - old_tags)
	end

	def updated_social_tags(old_tags, names)
		organize_social_tags(old_tags,  Squad.merged_tag_names(old_tags, names, visitor)) unless names.nil?
	end

end
