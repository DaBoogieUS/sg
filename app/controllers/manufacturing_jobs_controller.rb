class ManufacturingJobsController < ApplicationController
  before_filter :load_lineage
  before_action :set_manufacturing_job, only: [:show, :edit, :update, :destroy]

  # GET /manufacturing_jobs
  # GET /manufacturing_jobs.json
  def index
    @manufacturing_jobs = ManufacturingJob.all
    @manufacturing_jobs_index = true
    @manufacturing_jobs = ManufacturingJob.new
    redirect_to job_phase_path(@job,@phase)
  end

  # GET /manufacturing_jobs/1
  # GET /manufacturing_jobs/1.json
  def show
    @manufacturing_jobs_show = true
  end

  # GET /manufacturing_jobs/new
  def new
    @manufacturing_job = ManufacturingJob.new(manufacturing_job_params)
    @manufacturing_jobs_new = true
  end

  # GET /manufacturing_jobs/1/edit
  def edit
    @manufacturing_jobs_edit = true
  end

  # POST /manufacturing_jobs
  # POST /manufacturing_jobs.json
  def create
    @manufacturing_job = ManufacturingJob.new(manufacturing_job_params)

    respond_to do |format|
      if @manufacturing_job.save
        format.js   {}
        format.html { redirect_to phase_manufacturing_job_path(@phase, @manufacturing_job), notice_success: 'Manufacturing job created!' }
        format.json { render action: 'show', status: :created, location: @manufacturing_job }
      else
        format.html { render action: 'new' }
        format.json { render json: @manufacturing_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manufacturing_jobs/1
  # PATCH/PUT /manufacturing_jobs/1.json
  def update
    respond_to do |format|
      if @manufacturing_job.update(manufacturing_job_params)
        format.html { redirect_to phase_manufacturing_job_path(@phase, @manufacturing_job), notice_success: 'Manufacturing job updated!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @manufacturing_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manufacturing_jobs/1
  # DELETE /manufacturing_jobs/1.json
  def destroy
    @manufacturing_job.destroy
    respond_to do |format|
      format.html { redirect_to job_phase_path(@job, @phase) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def load_lineage
      @phase = Phase.find(params[:phase_id])
      @job = Job.find(@phase.job_id)
      @client = Client.find(@job.client_id)
    end

    def set_manufacturing_job
      @manufacturing_job = ManufacturingJob.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manufacturing_job_params
      params.fetch(:manufacturing_job, {}).permit(:phase_id, :name, :date, part_ids: [])
    end
end
