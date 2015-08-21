class ChangeColumnNameInWorks < ActiveRecord::Migration
  def change
  	rename_column :works, :content_type, :type
  	add_index "sources", ["host_id"], name: "index_sources_on_host_id"
  end
end
