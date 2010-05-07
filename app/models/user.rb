class User < ActiveRecord::Base
	# Keep track of all tasks this user has submitted.
	has_many :submitted_tasks, :class_name => "Task", :foreign_key => "submitter_id"
        # Keep track of tasks assigned to the user.
        has_many :users
	# Additionally, track comments this user has posted.
	has_many :comments

        # Connect to users, through the group_users model.
        has_many :group_users
        has_many :groups, :through => :group_users

        # We will want to verify some of the properties of the user.
        # Note that a number of validations, including email and username
        # presence and uniqueness, are included automatically by 
        # acts_as_authentic, below.
        validates_presence_of :first
        validates_presence_of :last

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
        # Mailer data is a hash with some env data for the mailer.
        def deliver_validation(mailer_data)
          # First, we need a token (done by authlogic)
          reset_perishable_token!  

          # Now, send it to the user.
          UserMailer.deliver_activation(self, mailer_data)
        end

        # Tell the login system the user is not activated if the activated
        # column has not been set.
        def active?
          activated == true
        end

        #default_scope :conditions => { :activated => true }

end
