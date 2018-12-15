class RemoveWorktimeFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :fixed_work_time, :float
    remove_column :users, :basic_work_time, :float
  end
end
