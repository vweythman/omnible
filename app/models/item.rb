class Item < ActiveRecord::Base
	belongs_to :generic

	def main_title
		name
	end

	def generic_name
		generic.name unless generic.nil?	
	end

	def self.organized_all(list = Item.includes(:generic))
		Item.organize(list)
	end

	def self.organize(items)
		list = Hash.new
		items.each do |item|
			list[item.generic.name] = Array.new if list[item.generic.name].nil?
			list[item.generic.name].push(item)
		end
		return list.sort
	end
end
