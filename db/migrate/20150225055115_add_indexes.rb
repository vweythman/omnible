class AddIndexes < ActiveRecord::Migration
  def change
  	add_index :chapters, :work_id
  	add_index :memberships, :cast_id
  	add_index :memberships, :character_id
  	add_index :relationships, :relator_id
  end
end
