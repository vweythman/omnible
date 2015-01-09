class CreateTermRelationships < ActiveRecord::Migration
  def change
    create_table :term_relationships do |t|
      t.belongs_to :broad
      t.belongs_to :narrow
    end
  end
end
