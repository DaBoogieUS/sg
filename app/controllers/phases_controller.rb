class PhasesController < ApplicationController
  before_filter :load_lineage
  before_action :set_phase, only: [:show, :edit, :update, :destroy]

  # GET /phases
  # GET /phases.json
  def index
    @phases = Phase.all
    @phases_index = true
    redirect_to client_job_path(@client,@job)
  end

  # GET /phases/1
  # GET /phases/1.json
  def show
    @phases_show = true
    @new_structure = @phase.structures.new
    @new_manufacturing_job = @phase.manufacturing_jobs.new
  end

  # GET /phases/new
  def new
    @phase = Phase.new
    @phases_new = true
    @no_top_nav = true
  end

  # GET /phases/1/edit
  def edit
    @phases_edit = true
  end

  # POST /phases
  # POST /phases.json
  def create
    @phase = Phase.new(phase_params)

    respond_to do |format|
      if @phase.save
        format.html { redirect_to job_phase_path(@job, @phase), notice_success: 'Phase created!' }
        format.json { render action: 'show', status: :created, location: @phase }
      else
        format.html { render action: 'new' }
        format.json { render json: @phase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /phases/1
  # PATCH/PUT /phases/1.json
  def update
    respond_to do |format|
      if @phase.update(phase_params)
        format.html { redirect_to job_phase_path(@job, @phase), notice_success: 'Phase updated!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @phase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /phases/1
  # DELETE /phases/1.json
  def destroy
    @phase.destroy
    respond_to do |format|
      format.html { redirect_to job_phases_path(@job) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def load_lineage
      @job = Job.find(params[:job_id])
      @client = Client.find(@job.client_id)
    end

    def set_phase
      @phase = Phase.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def phase_params
      params.require(:phase).permit(:job_id, :name, :manufacture_start, :manufacture_end, :install_start, :install_end, :structures_attributes => [:id, :_destroy, :name], :manufacturing_jobs_attributes => [:id, :_destroy, :name])
    end

end
