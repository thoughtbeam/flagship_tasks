class User < ActiveRecord::Base
	has_many :submitted_tasks, :class_name => "Task", :foreign_key => "submitter_id"
end
