# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
describers = 
	WorksTypeDescriber.create(
		[
			{ 
				name: 'BranchingStory',
				is_narrative: true,
				is_singleton: false,
				content_type: 'text',
				is_record: false,
				is_creative_expression: true
			}
		]
	)

=begin
describers = 
	WorksTypeDescriber.create(
		[
			{ 
				name: 'Article',
				is_narrative: false,
				is_singleton: true,
				content_type: 'text',
				is_record: false,
				is_creative_expression: false
			}, 
			{ 
				name: 'Journal',
				is_narrative: false,
				is_singleton: false,
				content_type: 'text',
				is_record: false,
				is_creative_expression: false
			}, 
			{
				name: 'Story',
				is_narrative: true,
				is_singleton: false,
				content_type: 'text',
				is_record: false,
				is_creative_expression: true
			}, 
			{
				name: 'ShortStory',
				is_narrative: true,
				is_singleton: true,
				content_type: 'text',
				is_record: false,
				is_creative_expression: true
			}, 
			{
				name: 'StoryLink',
				is_narrative: true,
				is_singleton: false,
				content_type: 'text',
				is_record: true,
				is_creative_expression: true
			}, 
			{
				name: 'Poem',
				is_narrative: false,
				is_singleton: false,
				content_type: 'text',
				is_record: false,
				is_creative_expression: true
			}, 
			{
				name: 'Biography',
				is_narrative: true,
				is_singleton: false,
				content_type: 'text',
				is_record: false,
				is_creative_expression: false
			}, 
			{
				name: 'Lyrics',
				is_narrative: false,
				is_singleton: true,
				content_type: 'text',
				is_record: false,
				is_creative_expression: true
			}, 
			{
				name: 'Podcast',
				is_narrative: false,
				is_singleton: true,
				content_type: 'audio',
				is_record: false,
				is_creative_expression: false
			}, 
			{
				name: 'Song',
				is_narrative: true,
				is_singleton: true,
				content_type: 'audio',
				is_record: false,
				is_creative_expression: true
			}
		]
	)

=end