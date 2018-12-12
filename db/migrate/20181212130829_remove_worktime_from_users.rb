class RemoveWorktimeFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :fixed_work_time, :time
    remove_column :users, :basic_work_time, :time
  end
end
