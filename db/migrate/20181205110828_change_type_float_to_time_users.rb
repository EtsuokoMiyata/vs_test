class ChangeTypeFloatToTimeUsers < ActiveRecord::Migration[5.1]
  def up
    change_column :users, :fixed_work_time, :time
    change_column :users, :basic_work_time, :time
  end

  def down
    change_column :users, :fixed_work_time, :float
    change_column :users, :basic_work_time, :float
  end
end
