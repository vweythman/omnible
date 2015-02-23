class CreateFacets < ActiveRecord::Migration
  def change
    create_table :facets do |t|
      t.string :name

      t.timestamps
    end
  end
end
