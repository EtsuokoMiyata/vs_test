class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
      t.datetime :in_time
      t.datetime :out_time
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :attendances, [:user_id, :created_at]
  end
end
