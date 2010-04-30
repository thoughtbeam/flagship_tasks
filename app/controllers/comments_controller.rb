class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.xml
  # Retrieves a list of all comments in the system.
  def index
    @comments = Comment.all

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
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  # Offers a form that creates a new comment.
  def new
    @comment = Comment.new

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
    @comment = Comment.new(params[:comment])

    respond_to do |format|
      if @comment.save
        format.html { redirect_to(@comment, :notice => 'Comment was successfully created.') }
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
    @comment = Comment.find(params[:id])

    respond_to do |format|
      # Comments can only be edited by the submitter (if not anonymous) and administrators.
      if !current_user or (!current_user.is_admin and @comment.user != current_user)
        format.html { redirect_to(@comment, :notice => 'You must be the poster of this comment or an administrator to edit it.') }
        format.xml { :status => :unprocessable_entity }
      elsif @comment.update_attributes(params[:comment])
        format.html { redirect_to(@comment, :notice => 'Comment was successfully updated.') }
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
          format.html { redirect_to(@comment, :notice => 'You must be an administrator to delete comments.') }
          format.xml { :status => :unprocessable_entity }
       end
       return
    end
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(comments_url) }
      format.xml  { head :ok }
    end
  end
end
