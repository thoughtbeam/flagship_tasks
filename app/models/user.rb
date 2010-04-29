class User < ActiveRecord::Base
	# Keep track of all tasks this user has submitted.
	has_many :submitted_tasks, :class_name => "Task", :foreign_key => "submitter_id"

        # Connect to users, through the group_users model.
        has_many :group_users
        has_many :groups, :through => :group_users

        # We don't want to register the same user id twice.
        validates_uniqueness_of :username

        # Require valid email and name
        validates_presence_of :first
        validates_presence_of :last
        validates_presence_of :email

        # Provide default ordering for views
        default_scope :order => 'last, first'

        # Provide the hook into the authlogic user module.
        acts_as_authentic

        # Provide an easy way to get at the fullname.
        def name
          first + " " + last
        end

        # Display lastname, firstname for any alphebitized lists.
        def alphaname
          last + ", " + first
        end

end
