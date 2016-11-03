class CreateRolecalls < ActiveRecord::Migration
  def change
    create_table :rolecalls do |t|
      t.string :avatar
      t.belongs_to :character, index: true, foreign_key: true
      t.belongs_to :casting, index: true, foreign_key: true
      t.text :description

      t.timestamps null: false
    end
  end
end
