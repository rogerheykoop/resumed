class CreateEducationHistories < ActiveRecord::Migration
  def change
    create_table :education_histories do |t|
      t.integer :resume_id
      t.string  :school_name
      t.date    :from
      t.date    :until
      t.timestamps null: false
    end
  end
end
