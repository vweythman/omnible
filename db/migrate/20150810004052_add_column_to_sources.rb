class AddColumnToSources < ActiveRecord::Migration
  def change
    add_column :sources, :type, :string
  end
end
