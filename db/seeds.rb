# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

adjectives = Adjective.create([
	{name: 'opinion'}, 
	{name: 'size'}, 
	{name: 'shape'}, 
	{name: 'age'}, 
	{name: 'color'}, 
	{name: 'origin'}, 
	{name: 'purpose'}
	])