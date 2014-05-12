class AddCostToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :cost, :text
  end
end
