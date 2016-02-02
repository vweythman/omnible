class RenameColumn < ActiveRecord::Migration
  def change
  	rename_column :creatorships, :user_id, :creator_id
  end
end
