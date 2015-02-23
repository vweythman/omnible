class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.belongs_to :left, index: true
      t.belongs_to :relator, index: true
      t.belongs_to :right, index: true

      t.timestamps
    end
  end
end
