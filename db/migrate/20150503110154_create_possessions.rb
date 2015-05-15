class CreatePossessions < ActiveRecord::Migration
  def change
    create_table :possessions do |t|
      t.belongs_to :character, index: true
      t.belongs_to :item, index: true

      t.timestamps
    end
  end
end
