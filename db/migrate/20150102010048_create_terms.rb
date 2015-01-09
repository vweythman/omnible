class CreateTerms < ActiveRecord::Migration
  def change
    create_table :facets do |t|
      t.string :name
      t.timestamps
  	end

    create_table :terms do |t|
      t.string :name
      t.belongs_to :facet, index: true
      t.timestamps
    end

    create_table :term_relationships do |t|
      t.belongs_to :broad
      t.belongs_to :narrow
	end
  end
end
