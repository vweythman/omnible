class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.belongs_to :item_type, index: true

      t.timestamps
    end
  end
end
