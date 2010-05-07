class CommentsController < ApplicationController
   # Anything to do with a task is done in the context of a task.
  # First thing to do is to fetch the @group and @project
  before_filter :get_task

  # Figure out the current task based on the url. This will be provided
  # as @group, and the collection of projects will be @parent.
  def get_task
    @task = Task.find(params[:task_id])
    @group = Group.find(params[:group_id])
    @project = Project.find(params[:project_id])
    @parent = @task.comments
  end

  # GET /comments
  # GET /comments.xml
  # Retrieves a list of all comments in the system.
  def index
    @comments = @parent.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  # Retrieves a specific comment given by ID and
  # displays its details.
  def show
    @comment = @parent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  # Offers a form that creates a new comment.
  def new
    @comment = @parent.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  # Offers a form that modifies an existing comment.
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.xml
  # Receives the results of the new form and actually creates
  # the new comment and saves it.
  def create
    @comment = @parent.new(params[:comment])
    if !current_user
      redirect_to([@group,@project,@task], :notice => 'Must be logged in to comment.' )
      return
    end

    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.html { redirect_to([@group,@project,@task], :notice => 'Comment was successfully created.') }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  # Receives the results of the edit form and actually updates
  # the comment data.
  def update
    @comment = @parent.find(params[:id])

    respond_to do |format|
      # Comments can only be edited by the submitter (if not anonymous) and administrators.
      if !current_user or (!current_user.is_admin and @comment.user != current_user)
        format.html { redirect_to([@group,@project,@task], :notice => 'You must be the poster of this comment or an administrator to edit it.') }
        format.xml { render :status => :unprocessable_entity }
      elsif @comment.update_attributes(params[:comment])
        format.html { redirect_to([@group,@project,@task], :notice => 'Comment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  # Attempts to destroy the comment given by ID.
  def destroy
    @comment = Comment.find(params[:id])
    if !current_user or !current_user.is_admin
       respond_to do |format|
          format.html { redirect_to([@group,@project,@task], :notice => 'You must be an administrator to delete comments.') }
          format.xml { render :status => :unprocessable_entity }
       end
       return
    end
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to([@group, @project, @task]) }
      format.xml  { head :ok }
    end
  end
end
