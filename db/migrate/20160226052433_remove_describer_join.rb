class RemoveDescriberJoin < ActiveRecord::Migration
  def change
  	drop_table :creator_categories_works_type_describers
  end
end
