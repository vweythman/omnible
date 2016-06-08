class AddTaggerType < ActiveRecord::Migration
  def change
  	rename_column :taggings, :work_id, :tagger_id
    add_column :taggings, :tagger_type, :string
  end
end
