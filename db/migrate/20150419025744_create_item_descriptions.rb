class CreateItemDescriptions < ActiveRecord::Migration
  def change
    create_table :item_descriptions do |t|
      t.belongs_to :item, index: true
      t.belongs_to :quality, index: true

      t.timestamps
    end
  end
end
