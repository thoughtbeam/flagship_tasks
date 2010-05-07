class UserSessionsController < ApplicationController
  # GET /user_session/new
  # Offers a form to create a new user session, i.e. log in.
  def new
    unless current_user_session.nil?
      redirect_to root_url, :notice => "You are already logged in."
      return
    end

    @user_session = UserSession.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_session }
    end
  end

  # POST /user_session
  # Creates a new user session, i.e. logs in.
  def create
    unless current_user_session.nil?
      redirect_to root_url, :notice => "You are already logged in."
      return
    end
    @user_session = UserSession.new(params[:user_session])

    if @user_session.save
      redirect_to(@user_session.user, :notice => "Login successful. Welcome!") 
    else
      render :action => "new" 
    end
  end

  # DELETE /user_session
  # Destroys the current user session, i.e. logs out.
  def destroy
    current_user_session.destroy
    redirect_to(root_url, :notice => "Logout Successful!")
  end
end
