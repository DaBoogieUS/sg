class JobsController < ApplicationController
  before_filter :load_lineage
  before_action :set_job, only: [:show, :edit, :update, :destroy]

  # GET /jobs
  # GET /jobs.json
  def index
    @jobs = @client.jobs.all
    @jobs_index = true
    redirect_to client_path(@client)
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
    @jobs_show = true
    @no_top_nav = true
  end

  # GET /jobs/new
  def new
    @job = @client.jobs.new
    @no_top_nav = true
    @jobs_new = true
  end

  # GET /jobs/1/edit
  def edit
    @jobs_edit = true
    @no_top_nav = true
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @job = @client.jobs.new(job_params)
    respond_to do |format|
      if @job.save
        format.html { redirect_to client_job_path(@client, @job), notice_success: 'Job created!' }
        format.json { render action: 'show', status: :created, location: @job }
      else
        format.html { render action: 'new' }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to client_jobs_path(@client), notice_success: 'Job updated!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to client_jobs_path(@client) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def load_lineage
      @client = Client.find(params[:client_id])
      @no_top_nav = true
    end

    def set_job
      @job = @client.jobs.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:client_id, :name, :location)
    end
end
