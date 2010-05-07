class GroupUsersController < ApplicationController
  # All operations on a GroupUser relationship object are done in
  # the context of a group, and namespaced to /group/:id/

  # Private methods defined at bottom:
  # get_group (finds the current group, provides @group, @parent
  # form_prep (gets some data needed to display the form

  # Before anything, figure out the @group from the URL parameters
  before_filter :get_group

  # GET /group_users
  # GET /group_users.xml
  def index
    @group_users = @parent.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @group_users }
    end
  end

  # GET /group_users/1
  # GET /group_users/1.xml
  def show
    @group_user = @parent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group_user }
    end
  end

  # GET /group_users/new
  # GET /group_users/new.xml
  def new
    # Make the blank group_user a member of this group (via @parent)
    @group_user = @parent.new
    
    if !current_user or (!current_user.is_admin and !@group.owners.include?(current_user))
       redirect_to @group, :notice => "You cannot add users to that group."
       return
    end

    form_prep #the view will need the listing of @users

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group_user }
    end
  end

  # GET /group_users/1/edit
  def edit
    @group_user = @parent.find(params[:id])
    form_prep # get the @users for the drop-down
  end

  # POST /group_users
  # POST /group_users.xml
  def create
    # Create the new user, given the params, but already a member of the group
    @group_user = @parent.new(params[:group_user])

    if !current_user or (!current_user.is_admin and !@group.owners.include?(current_user))
       redirect_to @group, :notice => "You cannot add users to that group."
       return
    end

    respond_to do |format|
      if @group_user.save
        format.html { redirect_to(@group, :notice => 'Group user was successfully created.') }
        format.xml  { render :xml => @group_user, :status => :created, :location => @group_user }
      else
        format.html { form_prep and render :action => "new" }
        format.xml  { render :xml => @group_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # POST /group_users/1/promote
  # POST /group_users/1/promote.xml
  # Promote the user to become an owner of the group.
  def promote
    @group_user = @parent.find(params[:id]) #get the record

    if !current_user or (!current_user.is_admin and !@group.owners.include?(current_user))
       redirect_to @group, :notice => "You cannot update users in that group."
       return
    end

    respond_to do |format|
      # We'll set is_owner to true. Remember update_attribute bypasses validations!
      if @group_user.update_attribute(:is_owner, true)
        format.html { redirect_to(@group, :notice => 'Group user was successfully promoted!') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # POST /group_users/1/demote
  # POST /group_users/1/demote.xml
  # Demote the user to be a non-owner for the group.
  def demote
    @group_user = @parent.find(params[:id]) #get the record

    if !current_user or (!current_user.is_admin and !@group.owners.include?(current_user)) or current_user == @group_user.user
       redirect_to @group, :notice => "You cannot demote that user."
       return
    end

    respond_to do |format|
      # We'll set is_owner to true. Remember update_attribute bypasses validations!
      if @group_user.update_attribute(:is_owner, false)
        format.html { redirect_to(@group, :notice => 'Group user is now a regulare member.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group_user.errors, :status => :unprocessable_entity }
      end
    end
  end



  # PUT /group_users/1
  # PUT /group_users/1.xml
  def update
    @group_user = @parent.find(params[:id]) #get the record

    respond_to do |format|
      if @group_user.update_attributes(params[:group_user])
        format.html { redirect_to(@group, :notice => 'Group user was successfully updated.') }
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
    @group_user = @parent.find(params[:id])
    @user = @group_user.user
    if !current_user or (!current_user.is_admin and !@group.users.include?(current_user))
       redirect_to @group, :notice => "You cannot remove users from that group."
       return
    end
    if @group_user.is_owner
       redirect_to @group, :notice => "You cannot remove an owner from a group."
       return
    end
    if !@group.owners.include?(current_user) and @user != current_user
       redirect_to @group, :notice => "You cannot remove that user from this group."
       return
    end
    
    @group_user.destroy

    respond_to do |format|
      format.html { redirect_to(@group) }
      format.xml  { head :ok }
    end
  end

  private

  # Figure out the current group, provide @group and @parent
  def get_group
    @group = Group.find(params[:group_id])
    @parent = @group.group_users
  end

  # Get info for the form.
  def form_prep
    @users = User.all
  end
end
