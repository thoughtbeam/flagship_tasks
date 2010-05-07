class ProjectsController < ApplicationController
  # Anything to do with a project is done in the context of a group.
  # First thing to do is to fetch the @group.
  before_filter :get_group

  # Figure out the current group based on the url. This will be provided
  # as @group, and the collection of projects will be @parent.
  def get_group
    @group = Group.find(params[:group_id])
    @parent = @group.projects
  end
  
  # GET /projects
  # GET /projects.xml
  # Lists all projects in the system.
  def index
    @projects = @parent.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  # Gives the full details for a single project given by ID.
  def show
    @project = @parent.find(params[:id])

    @tasks = @project.tasks

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  # Displays a form for creating a new project to the user.
  def new
    @project = @parent.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  # Displays a form for editing a project to the user.
  def edit
    @project = @parent.find(params[:id])
    # Only the owners of the project's group and administrators
    # can modify projects. Fail gracefully if the user is not allowed.
    if !@project.group.owners.include?(current_user) and !current_user.is_admin
        respond_to do |format|
            format.html { redirect_to(@project, :notice => "You need to be an owner of this group to do that.") }
            format.xml { render :status => :unprocessable_entity }
        end
        return
    end
  end

  # POST /projects
  # POST /projects.xml
  # Accepts the results of the new form to create a new project.
  def create
    @project = @parent.new(params[:project])
    logger.info "OH MY FUCING GOD!!!!" if @project.nil?
    logger.info @project

    # Only group owners and administrators can create projects assigned
    # to that group. Fail gracefully if the user is not allowed.
    respond_to do |format|
      if !@project.group.owners.include?(current_user) and !current_user.is_admin
        format.html { redirect_to(@project.group, :notice => "You need to be an owner of this group to do that.") }
        format.xml { render :status => :unprocessable_entity }
      elsif @project.save
        format.html { redirect_to([@group, @project], :notice => 'Project was successfully created.') }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  # Accepts the results of the edit form and attempts to modify the
  # given project.
  def update
    @project = @parent.find(params[:id])

    respond_to do |format|
      # Only the owners of the project's group and administrators can
      # modify a project. Fail gracefully if the user is not allowed.
      if !@project.group.owners.include?(current_user) and !current_user.is_admin
        format.html { redirect_to(@project, :notice => "You need to be an owner of this group to do that.") }
        format.xml { render :status => :unprocessable_entity }
      elsif @project.update_attributes(params[:project])
        format.html { redirect_to([@group, @project], :notice => 'Project was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  # Attempts to delete a project given by ID.
  def destroy
    @project = Project.find(params[:id])
    # Only administrators can permanently delete projects.
    # Fail gracefully if the user is not allowed.
    if !current_user or !current_user.is_admin
        respond_to do |format|
            format.html { redirect_to([@group, @project], :notice => "You don't have permission to do that.") }
            format.xml { render :status => :unprocessable_entity }
        end
        return
    end
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(group_url(@group)) }
      format.xml  { head :ok }
    end
  end
end
