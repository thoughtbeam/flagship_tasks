class UserSessionsController < ApplicationController
  # GET /user_sessions
  # GET /user_sessions.xml
  # Retrieves a list of all logged-in user sessions to be displayed.
  def index
    @user_sessions = UserSession.new
  end

  # GET /user_sessions/1
  # GET /user_sessions/1.xml
  # Displays the given logged-in user session.
  def show
    @user_session = UserSession.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user_session }
    end
  end

  # GET /user_sessions/new
  # GET /user_sessions/new.xml
  # Offers a form to create a new user session, i.e. log in.
  def new
    @user_session = UserSession.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_session }
    end
  end

  # POST /user_sessions
  # POST /user_sessions.xml
  # Creates a new user session, i.e. logs in.
  def create
    @user_session = UserSession.new(params[:user_session])

    if @user_session.save
      redirect_to(@user_session.user, :notice => "Login successful. Welcome!") 
    else
      render :action => "new" 
    end
  end

  # DELETE /user_sessions/1
  # DELETE /user_sessions/1.xml
  # Destroys the current user session, i.e. logs out.
  def destroy
    current_user_session.destroy
    redirect_to(root_url, :notice => "Logout Successful!")
  end
end
