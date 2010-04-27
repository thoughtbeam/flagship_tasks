class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.integer :project_id
      t.integer :submitter_id
      t.string :name
      t.text :body, :default => ""
      t.integer :status_id, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
