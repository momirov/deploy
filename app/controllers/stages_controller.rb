class StagesController < ApplicationController
  # GET /stages
  # GET /stages.json
  def index
    @project = Project.find(params[:project_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project.stages }
    end
  end

  # GET /stages/1
  # GET /stages/1.json
  def show
    @stage = Stage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @stage }
    end
  end

  def run
    @stage = Stage.find(params[:id])

    notice = "Deployment for #{@stage.title} is already running, please wait for the previous deployment to finish."

    if @stage.deployments.where(:status => :running).count == 0
      @deployment = Deployment.new
      @deployment.stage = @stage
      @deployment.user = current_user.login
      @deployment.project = @stage.project
      @deployment.status = :running
      @deployment.new_revision = @stage.get_next_version
      @deployment.old_revision = @stage.get_current_version
      @deployment.save

      @runner = Runner.new @deployment
      Celluloid::Actor["deployment_#{@deployment.id}"] = @runner
      @runner.async.deploy!

      notice = 'New deployment started'
    end

    respond_to do |format|
      format.html { redirect_to project_path(@stage.project), notice: notice }
      format.json { render json: @stage }
    end
  end

  # GET /stages/new
  # GET /stages/new.json
  def new
    @stage = Stage.new
    @project = Project.find(params[:project_id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @stage }
    end
  end

  # GET /stages/1/edit
  def edit
    @project = Project.find(params[:project_id])
    @stage = Stage.find(params[:id])
  end

  # POST /stages
  # POST /stages.json
  def create
    @project = Project.find(params[:project_id])
    @stage = @project.stages.create(params[:stage])

    respond_to do |format|
      if @stage.save
        format.html { redirect_to project_stages_path(@project), notice: 'Stage was successfully created.' }
        format.json { render json: @stage, status: :created, location: @stage }
      else
        format.html { render action: "new" }
        format.json { render json: @stage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /stages/1
  # PUT /stages/1.json
  def update
    @stage = Stage.find(params[:id])

    respond_to do |format|
      if @stage.update_attributes(params[:stage])
        format.html { redirect_to project_stages_path @stage.project, notice: 'Stage was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @stage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stages/1
  # DELETE /stages/1.json
  def destroy
    @stage = Stage.find(params[:id])
    @stage.destroy

    respond_to do |format|
      format.html { redirect_to project_stages_url params[:project_id] }
      format.json { head :no_content }
    end
  end
end
