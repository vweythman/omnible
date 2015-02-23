class CreateAppearances < ActiveRecord::Migration
  def change
    create_table :appearances do |t|
      t.belongs_to :work, index: true
      t.belongs_to :character, index: true
      t.string :role

      t.timestamps
    end
  end
end
