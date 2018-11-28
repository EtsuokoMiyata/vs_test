class AddTimeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :department, :string
    add_column :users, :fixed_work_time, :float
    add_column :users, :basic_work_time, :float
  end
end
