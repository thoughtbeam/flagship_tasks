class Group < ActiveRecord::Base
	has_many :projects # Connects this group to all projects owned by it.
end
