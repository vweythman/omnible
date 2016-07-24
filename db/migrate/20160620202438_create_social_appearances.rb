class CreateSocialAppearances < ActiveRecord::Migration
  def change
    create_table :social_appearances do |t|
      t.belongs_to :social_group, index: true, foreign_key: true
      t.belongs_to :work, index: true, foreign_key: true

      t.timestamps null: false
    end

  	rename_column :memberships, :group_id, :social_group_id
  end
end
