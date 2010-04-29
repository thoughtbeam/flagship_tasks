class Group < ActiveRecord::Base
	has_many :projects # Connects this group to all projects owned by it.

        # Connect to users, through the group_users model.
        has_many :group_users
        has_many :users, :through => :group_users

        # Some users are owners with special priveleges.
        has_many :owners, :through => :group_users, :source => :user, :conditions => ['is_owner = ?', true]
end
