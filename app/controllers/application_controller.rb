class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by inserting a secret into each form
  # that is rendered and checking for it when the form is received.
  protect_from_forgery

  # Don't log sensitive data (passwords).
  filter_parameter_logging :password, :password_confirmation
  # Make the current_user_session and current_user methods
  # available to the views.
  helper_method :current_user_session, :current_user

  private
  # Return a handle to the session of the user contacting the system.
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  # Return a handle to the user contacting the system.
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

end
