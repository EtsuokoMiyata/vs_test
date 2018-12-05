class ChangeFloStringToTimUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :fixed_work_time, :time
    change_column :users, :basic_work_time, :time
  end
end
