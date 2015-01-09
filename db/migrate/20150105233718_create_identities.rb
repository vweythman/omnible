class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :name
      t.text :description
      t.timestamps
    end
    create_table :groups do |t|
      t.string :name
      t.string :summary
      t.timestamps
    end
  end
end
