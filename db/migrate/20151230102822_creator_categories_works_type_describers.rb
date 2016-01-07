class CreatorCategoriesWorksTypeDescribers < ActiveRecord::Migration
  def change
    create_table :creator_categories_works_type_describers, :id => false do |t|
      t.integer :creator_category_id
      t.integer :works_type_describer_id
    end
  end
end
