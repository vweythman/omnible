class CreateIdentifiers < ActiveRecord::Migration
  def change
    create_table :identifiers do |t|
      t.string :name
      t.belongs_to :character, index: true

      t.timestamps
    end
  end
end
