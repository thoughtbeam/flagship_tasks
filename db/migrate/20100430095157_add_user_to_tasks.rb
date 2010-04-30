class AddUserToTasks < ActiveRecord::Migration
  def self.up
    change_table(:tasks) do |t|
      t.references :user
    end
  end

  def self.down
    remove_column :tasks, :user_id
  end
end
