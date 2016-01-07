class CreateUserSkins < ActiveRecord::Migration
  def change
    create_table :skins do |t|
      t.string :title
      t.belongs_to :uploader, index: true, foreign_key: true
      t.text :style

      t.timestamps null: false
    end
  end
end
