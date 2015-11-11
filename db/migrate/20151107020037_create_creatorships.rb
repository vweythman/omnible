class CreateCreatorships < ActiveRecord::Migration
  def change
  	create_table :creator_categories do |t|
  		t.string :name, unique: true
      t.timestamps null: false
  	end
    create_table :creatorships do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :work, index: true, foreign_key: true
      t.belongs_to :creator_category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
