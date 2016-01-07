class CreateSkinnings < ActiveRecord::Migration
  def change
    create_table :skinnings do |t|
      t.belongs_to :work, index: true, foreign_key: true
      t.belongs_to :skin, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
