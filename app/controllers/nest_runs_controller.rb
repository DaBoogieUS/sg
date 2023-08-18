class NestRunsController < ApplicationController
  before_filter :load_lineage
  before_action :set_nest_run, only: [:show, :edit, :update, :destroy]

  # GET /nest_runs
  # GET /nest_runs.json
  def index
    @nest_runs = NestRun.all
    @nest_runs_index = true
    redirect_to phase_manufacturing_job_path(@phase,@manufacturing_job)
  end

  # GET /nest_runs/1
  # GET /nest_runs/1.json
  def show
    @nest_runs_show = true
  end

  # GET /nest_runs/new
  def new
    # @nest_runs_new = true
    # @nest_run = NestRun.new
  end

  # POST /nest_runs
  # POST /nest_runs.json
  def create
    @nest_run = NestRun.new(nest_run_params)

    respond_to do |format|
      if @nest_run.save
        format.html { redirect_to @nest_run, notice_success: 'Nest run created!' }
        format.json { render action: 'show', status: :created, location: @nest_run }
      else
        format.html { render action: 'new' }
        format.json { render json: @nest_run.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nest_runs/1
  # PATCH/PUT /nest_runs/1.json
  def update
    respond_to do |format|
      if @nest_run.update(nest_run_params)
        format.html { redirect_to @nest_run, notice_success: 'Nest run updated!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @nest_run.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nest_runs/1
  # DELETE /nest_runs/1.json
  def destroy
    @nest_run.destroy
    respond_to do |format|
      format.html { redirect_to nest_runs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def load_lineage
      @manufacturing_job = ManufacturingJob.find(params[:manufacturing_job_id])
      @phase = Phase.find(@manufacturing_job.phase_id)
      @job = Job.find(@phase.job_id)
      @client = Client.find(@job.client_id)
    end

    def set_nest_run
      @nest_run = NestRun.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def nest_run_params
      params.require(:nest_run).permit(:manufacturing_job_id, :material_id)
    end
end
