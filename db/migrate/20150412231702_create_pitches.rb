class CreatePitches < ActiveRecord::Migration
  def change
    create_table :pitches do |t|
      t.string :title
      t.text :about
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
