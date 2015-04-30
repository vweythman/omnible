class CreateAdjectivations < ActiveRecord::Migration
  def change
    create_table :adjectivations do |t|
      t.belongs_to :quality, index: true
      t.belongs_to :adjective, index: true

      t.timestamps
    end
  end
end
