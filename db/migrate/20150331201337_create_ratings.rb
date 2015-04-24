class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.belongs_to :work, index: true
      t.integer :violence
      t.integer :sexuality
      t.integer :language
      t.integer :overall

      t.timestamps
    end
  end
end
