class TasksController < ApplicationController
  # Anything to do with a project is done in the context of a group.
  # First thing to do is to fetch the @group and @project
  before_filter :get_project

  # Figure out the current group based on the url. This will be provided
  # as @group, and the collection of projects will be @parent.
  def get_project
    @group = Group.find(params[:group_id])
    @project = Project.find(params[:project_id])
    @parent = @project.tasks
  end

  # GET /tasks
  # GET /tasks.xml
  # Retrieves a list of the system's tasks.
  def index
    @tasks = @parent.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.xml
  # Displays the details of the given task.
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  # Shows a form to create a new task.
  def new
    @task = @parent.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  # Shows a form to edit the given task.
  def edit
    @task = @parent.find(params[:id])
    # Only allow administrators and group members to edit tasks.
    # Return others to the task page.
    if !@task.project.group.users.include?(current_user) and !current_user.is_admin
        respond_to do |format|
            format.html { redirect_to(@task, :notice => "You need to be a member of this group to do that.") }
            format.xml { render :status => :unprocessable_entity }
        end
        return
    end
  end

  # POST /tasks
  # POST /tasks.xml
  # Receives the form data from the new form.
  def create
    @task = @parent.new(params[:task])

    # Set submitter
    if(!current_user.is_admin)
      @task.submitter=current_user
    end

    # Set status if nesc.
    if(!current_user.is_admin && !@task.project.group.owners.include?(current_user))
      @task.status='Unverified'
    end

    # Only allow administrators and group members to create tasks.
    # Return others to the task page.
    if !@task.project.group.users.include?(current_user) and !current_user.is_admin
        respond_to do |format|
            format.html { redirect_to(@task.project, :notice => "You need to be a member of this group to do that.") }
            format.xml { render :status => :unprocessable_entity }
        end
        return
    end

    respond_to do |format|
      if @task.save
        format.html { redirect_to([@group, @project], :notice => 'Task was successfully created.') }
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  # Receives the output from the edit form. Updates the task
  # with new data.
  def update
    @task = @parent.find(params[:id])

    respond_to do |format|
      # Only group members and administrators can modify tasks.
      # Return others to the task page.
      if !@task.project.group.users.include?(current_user) and !current_user.is_admin
        format.html { redirect_to([@group, @project], :notice => "You need to be a member of this group to do that.") }
        format.xml { render :status => :unprocessable_entity }
      elsif @task.update_attributes(params[:task])
        format.html { redirect_to([@group, @project], :notice => 'Task was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  # Attempts to delete the given task from the database.
  def destroy
    @task = Task.find(params[:id])
    # Only administrators can completely delete tasks.
    if !current_user or !current_user.is_admin
        respond_to do |format|
            format.html { redirect_to([@group, @project], :notice => "You don't have permission to do that.") }
            format.xml { render :status => :unprocessable_entity }
        end
        return
    end
    @task.destroy

    respond_to do |format|
      format.html { redirect_to(tasks_url) }
      format.xml  { head :ok }
    end
  end
end
