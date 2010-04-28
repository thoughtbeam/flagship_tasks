class UserSessionsController < ApplicationController
  # GET /user_sessions
  # GET /user_sessions.xml
  def index
    @user_sessions = UserSession.new
  end

  # GET /user_sessions/1
  # GET /user_sessions/1.xml
  def show
    @user_session = UserSession.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user_session }
    end
  end

  # GET /user_sessions/new
  # GET /user_sessions/new.xml
  def new
    @user_session = UserSession.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_session }
    end
  end

  # POST /user_sessions
  # POST /user_sessions.xml
  def create
    @user_session = UserSession.new(params[:user_session])

    if @user_session.save
      redirect_to(root_path, :notice => "Login successful!") 
    else
      render :action => "new" 
    end
  end

  # DELETE /user_sessions/1
  # DELETE /user_sessions/1.xml
  def destroy
    current_user_session.destroy
    redirect_to(root_url, :notice => "Logout Successful!")
  end
end
