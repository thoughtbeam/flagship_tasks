class GroupsController < ApplicationController
  # GET /groups
  # GET /groups.xml
  # Displays an index of all groups in the system.
  def index
    @groups = Group.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.xml
  # Displays the details of a single group given by ID.
  def show
    @group = Group.find(params[:id])

    # Collect users and owners, we'll want to display them.
    @users = @group.users
    @owners = @group.owners

    # and projects, too.
    @projects = @group.projects

    # Don't need to display an owner as a user, too!
    @users.delete_if { |u| @owners.include? u }

    # We'll also want to display our projects.
    @projects = @group.projects


    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.xml
  # Offers the user a form for creating a new group.
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/1/edit
  # Offers the user a form for modifying a group given by ID.
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.xml
  # Accepts the results of the form created in new and tries
  # to use it to create a new group.
  def create
    @group = Group.new(params[:group])

    respond_to do |format|
      if !current_user || (!current_user.is_admin)
        format.html { redirect_to(@group, :notice => 'No permissions to create groups.')}
        format.xml { render :xml => @group.errors, :status => :unprocessable_entity }
      elsif @group.save
        format.html { redirect_to(@group, :notice => 'Group was successfully created.') }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  # Accepts the results of the form created in edit and tries
  # to use it to modify the given group.
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if !current_user || (!current_user.is_admin && !@group.owners.include?(current_user))
        format.html { redirect_to(@group, :notice => 'No permissions to edit group.')}
        format.xml { render :xml => @group.errors, :status => :unprocessable_entity }

      elsif @group.update_attributes(params[:group])
        format.html { redirect_to(@group, :notice => 'Group was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  # Attempts to destroy the group given by ID.
  def destroy
    @group = Group.find(params[:id])
    # Only administrators can permanently delete groups.
    # Fail gracefully if the user is not allowed.
    if !current_user or !current_user.is_admin
        respond_to do |format|
            format.html { redirect_to(@group, :notice => "You don't have permission to do that.") }
            format.xml { render :status => :unprocessable_entity }
        end
        return
    end
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
    end
  end
end
