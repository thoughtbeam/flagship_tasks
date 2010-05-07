class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  # Retrieves and displays a list of users in the system.
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  # Shows the details about one specific user.
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  # Displays a form to the user to create a new user.
  def new
    unless current_user_session.nil?
      redirect_to root_url, :notice => "You are already logged in."
      return
    end
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  # Displays a form to edit a given user.
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  # Receives the results of the new form and uses them to
  # create a new user.
  def create
    unless current_user_session.nil?
      redirect_to root_url, :notice => "You are already logged in."
      return
    end
    @user = User.new(params[:user])
    @user.activated = false

    respond_to do |format|
      if @user.save
        @user.deliver_validation
        format.html { redirect_to(root_url, :notice => 'Thank you for registering! You will recieve an email with instructions to activate shortly.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  # Receives the results of the edit form and uses them to
  # alter the given user.
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  # Attempts to permanently destroy the given user.
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  # /validate?token=:code
  def validate
    @user = User.find_by_perishable_token(params[:token])
    
    if @user.nil?
      redirect_to root_url, :notice => "Validation failed. Please try again."
     else
      @user.update_attribute(:activated, true)
      redirect_to root_url, :notice => "Validation successful. Welcome!"
    end
  end
end
