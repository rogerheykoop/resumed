class AddPositionToWorkHistories < ActiveRecord::Migration
  def change
	add_column :work_histories,:position,:string
  end
end
