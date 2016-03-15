class CreateWorkConnections < ActiveRecord::Migration
  def change
    create_table :work_connections do |t|
      t.belongs_to :tagged, index: true, foreign_key: true
      t.belongs_to :tagger, index: true, foreign_key: true
      t.string :nature

      t.timestamps null: false
    end
  end
end
