class CreateWorkOpinions < ActiveRecord::Migration
  def change
    create_table :work_opinions do |t|
      t.belongs_to :work, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true
      t.integer :value

      t.timestamps null: false
    end
  end
end
