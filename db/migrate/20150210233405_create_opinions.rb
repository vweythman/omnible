class CreateOpinions < ActiveRecord::Migration
  def change
    create_table :opinions do |t|
      t.belongs_to :character, index: true
      t.integer :recip_id
      t.string  :recip_type
      t.integer :warmth
      t.integer :respect
      t.text :about

      t.timestamps
    end
  end
end
