class GroupUsersController < ApplicationController
  # GET /group_users
  # GET /group_users.xml
  def index
    @group_users = GroupUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @group_users }
    end
  end

  # GET /group_users/1
  # GET /group_users/1.xml
  def show
    @group_user = GroupUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group_user }
    end
  end

  # GET /group_users/new
  # GET /group_users/new.xml
  def new
    @group_user = GroupUser.new
    
    form_prep

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group_user }
    end
  end

  # GET /group_users/1/edit
  def edit
    @group_user = GroupUser.find(params[:id])
    form_prep
  end

  # POST /group_users
  # POST /group_users.xml
  def create
    @group_user = GroupUser.new(params[:group_user])

    respond_to do |format|
      if @group_user.save
        format.html { redirect_to(@group_user, :notice => 'Group user was successfully created.') }
        format.xml  { render :xml => @group_user, :status => :created, :location => @group_user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /group_users/1
  # PUT /group_users/1.xml
  def update
    @group_user = GroupUser.find(params[:id])

    respond_to do |format|
      if @group_user.update_attributes(params[:group_user])
        format.html { redirect_to(@group_user, :notice => 'Group user was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /group_users/1
  # DELETE /group_users/1.xml
  def destroy
    @group_user = GroupUser.find(params[:id])
    @group_user.destroy

    respond_to do |format|
      format.html { redirect_to(group_users_url) }
      format.xml  { head :ok }
    end
  end

  private

  # Get info for the form.
  def form_prep
    @users = User.all
    @groups = Group.all
  end
end
