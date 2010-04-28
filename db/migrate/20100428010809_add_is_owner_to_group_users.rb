class AddIsOwnerToGroupUsers < ActiveRecord::Migration
  def self.up
    add_column :group_users, :is_owner, :boolean
  end

  def self.down
    remove_column :group_users, :is_owner
  end
end
