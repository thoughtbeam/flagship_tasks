class Project < ActiveRecord::Base
	validates :name, :presence => true, :length => { :minimum => 5 }
	validates :active, :presence => true
	validates :group_id, :presence => true
	belongs_to :group # Connects the project to the group that owns it.
end
