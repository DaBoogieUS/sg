class NestsController < ApplicationController
  before_action :load_lineage
  before_action :set_nest, only: [:show, :edit, :update, :destroy, :image]

  # GET /nests
  # GET /nests.json
  def index
    @nests = Nest.all
    redirect_to manufacturing_job_nest_run_path(@manufacturing_job,@nest_run)
  end

  # GET /nests/1
  # GET /nests/1.json
  def show
    @nests_show = true

    respond_to do |format|
      format.html
      format.svg do
        send_data(@nest.svg, type: 'image/svg+xml', disposition: 'inline')
      end
    end
  end

  def image
    @nests_show = true
  end

  # GET /nests/new
  def new
    @nest = Nest.new
  end

  # GET /nests/1/edit
  def edit
  end

  # POST /nests
  # POST /nests.json
  def create
    @nest = Nest.new(nest_params)

    respond_to do |format|
      if @nest.save
        format.html { redirect_to manufacturing_job_nest_run_path(@manufacturing_job,@nest_run), notice_success: 'Nest created!' }
        format.json { render action: 'show', status: :created, location: @nest }
      else
        format.html { render action: 'new' }
        format.json { render json: @nest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nests/1
  # PATCH/PUT /nests/1.json
  def update
    respond_to do |format|
      if @nest.update(nest_params)
        format.html { redirect_to :back, notice_success: 'Nest updated.' }
        # format.html { redirect_to manufacturing_job_nest_run_path(@manufacturing_job,@nest_run), notice_success: 'Nest updated!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @nest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nests/1
  # DELETE /nests/1.json
  def destroy
    @nest.destroy
    respond_to do |format|
      format.html { redirect_to manufacturing_job_nest_run_path(@manufacturing_job,@nest_run) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def load_lineage
      @nest_run = NestRun.find(params[:nest_run_id])
      @manufacturing_job = ManufacturingJob.find(@nest_run.manufacturing_job_id)
      @phase = Phase.find(@manufacturing_job.phase_id)
      @job = Job.find(@phase.job_id)
      @client = Client.find(@job.client_id)
    end
    def set_nest
      @nest = Nest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def nest_params
      params.require(:nest).permit(:nest_run_id, :is_manufactured)
    end
end
