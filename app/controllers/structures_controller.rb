class StructuresController < ApplicationController
  before_filter :load_lineage
  before_action :set_structure, only: [:show, :edit, :update, :destroy]

  # GET /structures
  # GET /structures.json
  def index
    @structures = Structure.all
    @structures_index = true
    @structure = Structure.new
    redirect_to job_phase_path(@job,@phase)
  end

  # GET /structures/1
  # GET /structures/1.json
  def show
    @structures_show = true
    @new_panel = Panel.new
  end

  # GET /structures/new
  def new
    @structure = Structure.new(structure_params)
    @structures_new = true
  end

  # GET /structures/1/edit
  def edit
    @structures_edit = true
  end

  # POST /structures
  # POST /structures.json
  def create
    @structure = Structure.new(structure_params)

    respond_to do |format|
      if @structure.save
        format.js   {}
        format.html { redirect_to phase_structure_path(@phase,@structure), notice_success: 'Structure created!' }
        format.json { render action: 'show', status: :created, location: @structure }
      else
        format.html { render action: 'new' }
        format.json { render json: @structure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /structures/1
  # PATCH/PUT /structures/1.json
  def update
    respond_to do |format|
      if @structure.update(structure_params)
        format.html { redirect_to phase_structure_path(@phase, @structure), notice_success: 'Structure updated!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @structure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /structures/1
  # DELETE /structures/1.json
  def destroy
    @structure.destroy
    respond_to do |format|
      format.html { redirect_to job_phase_path(@job,@phase) }
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

    def set_structure
      @structure = Structure.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def structure_params
      params.fetch(:structure, {}).permit(:phase_id, :name, :quick_w, :quick_l, :quick_h, :quick_def, :quick_bur)
    end
end
