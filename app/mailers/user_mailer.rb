class UserMailer < ActionMailer::Base
  default :from => "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.actionmailer.user_mailer.activation.subject
  #

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
