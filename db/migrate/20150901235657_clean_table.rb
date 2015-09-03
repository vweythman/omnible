class CleanTable < ActiveRecord::Migration
  def change

    add_column :events, :uploader_id, :integer
    add_column :groups, :uploader_id, :integer
    add_column :places, :uploader_id, :integer
    remove_column :respondences, :response_type
  end
end
