class Task < ActiveRecord::Base
	# Each task is associated with one project and is submitted by one
	# user. The user, however, can be nil, representing a task created
	# by an anonymous user.
	belongs_to :project, :touch => true
	belongs_to :submitter, :class_name => "User"
	# Each task can have an unlimited number of comments.
        # These comments are deleted when the task is.
	has_many :comments, :dependent => :destroy
	# Each task must belong to a project.
	validates :project_id, :presence => true
	# The status must be one of:
	# -1 : Invalid
	#  0 : Unverified
	#  1 : Accepted
	#  2 : In Progress
	#  3 : Done
	validates :status_id, :numericality => { :only_integer => true, :greater_than_or_equal_to => -1, :less_than_or_equal_to => 3 }

	# Constant dictionary indicating the human-readable definitions of 
	# the five different statuses.
	Statuses = {-1 => "Invalid", 0 => "Unverified", 1 => "Accepted", 2 => "In Progress", 3 => "Done" }

  # convient method to access the array externally (for forms).
  def statuses
    Statuses
  end

	# Retrieves the human-readable definition of this task's status.
	def status (status = nil)
		return Statuses[self.status_id]
	end
	# Sets the status of this task based on the given human-readable
	# definition.
	def status= (status)
		raise IndexError, "Invalid status" unless Statuses.has_value?(status)
		self.status_id = Statuses.index(status)
	end
end
