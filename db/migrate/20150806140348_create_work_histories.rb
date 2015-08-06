class CreateWorkHistories < ActiveRecord::Migration
  def change
    create_table :work_histories do |t|
      t.integer :resume_id
      t.string :company_name
      t.date :from
      t.date :until

      t.timestamps null: false
    end
  end
end
