class AddEducatonToEducationHistories < ActiveRecord::Migration
  def change
	add_column :education_histories,:education,:string
  end
end
