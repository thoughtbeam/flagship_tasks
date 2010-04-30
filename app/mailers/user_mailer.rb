class UserMailer < ActionMailer::Base
  default :from => "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.actionmailer.user_mailer.activation.subject
  #
  def activation(user)
    @user = user

    mail :to => user.email
  end
end
