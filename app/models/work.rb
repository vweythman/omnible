class Work < ActiveRecord::Base
	default_scope {order('lower(title) ASC')}

	validates :title, length: { maximum: 250 }, presence: true

	# Associations
	belongs_to :user
	has_many :collections
	has_many :anthologies, :through => :collections
	
	has_many :casts
	has_many :chapters
	has_many :notes
	
	has_many :conceptions
	has_many :concepts, :through => :conceptions

	# characters
	has_many :appearances
	has_many :characters, :through => :appearances
	has_many :main_characters, -> { where(appearances: {role: 'main'}) }, :through => :appearances, :class_name => 'Character', source: :character, :foreign_key => 'character_id'
	has_many :side_characters, -> { where(appearances: {role: 'side'}) }, :through => :appearances, :class_name => 'Character', source: :character, :foreign_key => 'character_id'
	has_many :mentioned_characters, -> { where(appearances: {role: 'mentioned'}) }, :through => :appearances, :class_name => 'Character', source: :character, :foreign_key => 'character_id'

	# NESTED ATTRIBUTION
	accepts_nested_attributes_for :appearances, :allow_destroy => true
	accepts_nested_attributes_for :conceptions, :allow_destroy => true

	# Other Class Variables
	attr_reader :content_distribution
	def after_initialize
		content_distribution()
	end

	# public methods
	def main_title
		title
	end

	def showcases
		if self.content_distribution[:chapters] > 0
			[self.chapters.first]
		elsif self.content_distribution[:notes] > 0
			self.notes
		else
			[]
		end
	end

	def content_distribution
		@content_distribution = {
			:chapters => Chapter.where(:work_id => self.id).count,
			:notes =>       Note.where(:work_id => self.id).count
		}
	end

	def next_chapter_num
		chapters.empty? ? 1 : (self.chapters.last.position + 1)
	end

	def self.null_state
		NullWork.new
	end
end

class NullWork
	def main_title
		"Works"
	end

	def part_of
		:works
	end

	def id
		nil
	end
end
