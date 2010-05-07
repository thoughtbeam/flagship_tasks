class Group < ActiveRecord::Base
	has_many :projects # Connects this group to all projects owned by it.
	has_many :active_projects, :class_name => "Project", :conditions => ['active = ?', true]
	has_many :inactive_projects, :class_name => "Project", :conditions => ['active = ?', false]

        # Connect to users, through the group_users model.
        has_many :group_users
        has_many :users, :through => :group_users

        # Some users are owners with special priveleges.
        has_many :owners, :through => :group_users, :source => :user, :conditions => ['is_owner = ?', true]

        # Order alphabetically by default.
        default_scope :order => 'name'
end
