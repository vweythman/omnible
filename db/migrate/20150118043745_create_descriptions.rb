class CreateDescriptions < ActiveRecord::Migration
  def change
    create_table :descriptions do |t|
      t.belongs_to :character, index: true
      t.belongs_to :identity, index: true
    end
  end
end
