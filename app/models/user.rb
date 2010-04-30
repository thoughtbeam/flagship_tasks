class User < ActiveRecord::Base
	# Keep track of all tasks this user has submitted.
	has_many :submitted_tasks, :class_name => "Task", :foreign_key => "submitter_id"
	# Additionally, track comments this user has posted.
	has_many :comments

        # Connect to users, through the group_users model.
        has_many :group_users
        has_many :groups, :through => :group_users

        # Require valid email and name
        validates_presence_of :first
        validates_presence_of :last
        validates_presence_of :email
        validates_presence_of :username

        # We don't want to register the same user id or email twice.
        validates_uniqueness_of :username
        validates_uniqueness_of :email

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

        # Do the mailer, set the token.
        def deliver_validation
          # First, we need a token (done by authlogic)
          reset_perishable_token!  

          # Now, send it to the user.
          UserMailer.activation(self)
        end

        # Tell the login system the user is not activated if the activated
        # column has not been set.
        def active?
          activated == true
        end

        default_scope :conditions => { :activated => true }

end
