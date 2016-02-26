class CreateWorkBylinings < ActiveRecord::Migration
  def change
    create_table :work_bylinings do |t|
      t.belongs_to :creator, index: true, foreign_key: true
      t.belongs_to :describer, index: true, foreign_key: true
      t.boolean :prime, default: false

      t.timestamps null: false
    end
  end
end
