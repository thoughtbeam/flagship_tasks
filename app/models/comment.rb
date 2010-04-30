class Comment < ActiveRecord::Base
	# Each comment is written by a user on a task.
	belongs_to :user
	belongs_to :task
	# Each comment must be attached to a task.
	validates :task_id, :presence => true
end
