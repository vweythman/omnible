class CreateCharacterInfos < ActiveRecord::Migration
  def change
    create_table :character_infos do |t|
      t.string :title
      t.text :content, null: false
      t.belongs_to :character, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
