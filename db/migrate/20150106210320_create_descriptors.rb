class CreateDescriptors < ActiveRecord::Migration
  def change
    create_table :character_term, :id => false do |t|
      t.belongs_to :character, index: true
      t.belongs_to :term, index: true
    end
  end
end
