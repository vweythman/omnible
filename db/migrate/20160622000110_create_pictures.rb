class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.belongs_to :work, index: true, foreign_key: true
      t.string :title
      t.string :artwork
      t.text :description

      t.timestamps null: false
    end
  end
end
