# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

=begin
describers = 
	WorksTypeDescriber.create(
		[
			{
				name: "Article",
				content_type: "text",
				is_singleton: true,
				is_record:    false,
				status: "Nonfiction"
			},
			{
				name: "Journal",
				content_type: "text",
				is_record:    false,
				is_singleton: false,
				status: "Nonfiction"
			},
			{
				name: "ShortStory",
				content_type: "text",
				is_record:    false,
				is_singleton: false,
				status: "Fictional Narrative"
			},
			{
				name: "Story",
				content_type: "text",
				is_record:    false,
				is_singleton: true,
				status: "Fictional Narrative"
			},
			{
				name: "StoryLink",
				content_type: "reference",
				is_record:    true,
				is_singleton: false,
				status: "Fictional Narrative"
			},
			{
				name: "Poem",
				content_type: "text",
				is_record:    false,
				is_singleton: true,
				status: "Creative Expression"
			},
			{
				name: "BranchingStory,"
				content_type: "text",
				is_record:    false,
				is_singleton: false,
				status: "Fictional Narrative"
			},
			{
				name: "Record",
				content_type: "data",
				is_singleton: true,
				is_record:    true,
				status: "Nonfiction"
			},
			{
				name: "Art",
				content_type: "picture",
				is_record:    false,
				is_singleton: false,
				status: "Creative Expression"
			},
			{
				name: "Comic",
				content_type: "picture",
				is_record:    false,
				is_singleton: false,
				status: "Fictional Narrative"
			},
			{
				name: "Music Video",
				content_type: "video",
				is_record:    false,
				is_singleton: true,
				status: "Creative Expression"
			}
		]
	)

=end