# This class is used to send email to  auser about various system events,
# such as new user verification, or task assignments.
class UserMailer < ActionMailer::Base
  # Note that the :host option that determines the base URL for all 
  # requests is set in ApplicationController based on the host of the
  # most recent request.

  # We will send the mail from a fake address.
  # The domain used will be the HTTP address of the server.
  # The best way to get this without destroying encapsulation is to use
  # the same host as the :host option.
  default :from => "no-reply@" + ActionMailer::Base.default_url_options[:host].gsub(/\/.*/, '')

  # How we send the mail to the user that verifies their email
  # and lets them verify their account.
  def activation(user)
    @user = user

    mail :to => user.email
  end

  # Alert user to a new task assigned to them.
  def new_task(task)
    @task = task
    mail :to => task.user.email
  end

  # Alert usre to an existing task they've been assigned to,
  # or if a task they are assigned or subscribed to gets updated
  def updated_task(task)
    @task = task
    mail :to => task.user.email
  end
end
