class Project < ActiveRecord::Base
	validates :name, :presence => true, :length => { :minimum => 3 } # A project must have a name.
	validates :group_id, :presence => true # A project must belong to a group.
	belongs_to :group # Connects the project to the group that owns it.
	has_many :tasks, :order => 'status_id DESC', :dependent => :destroy # Each project can have an unlimited number of tasks.
end
