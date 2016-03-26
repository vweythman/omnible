class RemoveDescriberNarrativeColumns < ActiveRecord::Migration
  def change
    remove_column :works_type_describers, :is_creative_expression
    remove_column :works_type_describers, :is_narrative
  end
end
