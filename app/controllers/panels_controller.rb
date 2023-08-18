class PanelsController < ApplicationController
  before_filter :load_lineage
  before_action :set_panel, only: [:show, :edit, :update, :destroy]

  # GET /panels
  # GET /panels.json
  def index
    @panels = Panel.all
    @panel = Panel.new
    @panels_index = true
    redirect_to phase_structure_path(@phase,@structure)
  end

  # GET /panels/1
  # GET /panels/1.json
  def show
    @panels_show = true
  end

  # GET /panels/new
  def new
    @panel = Panel.new
    @panels_new = true
  end

  # GET /panels/1/edit
  def edit
    @panels_edit = true
  end

  # POST /panels
  # POST /panels.json
  def create
    @panel = Panel.new(panel_params)

    respond_to do |format|
      if @panel.save
        format.js   {}
        format.html { redirect_to phase_structure_path(@phase,@structure), notice_success: 'Panel created!' }
        format.json { render action: 'show', status: :created, location: @panel }
      else
        format.html { render action: 'new' }
        format.json { render json: @panel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /panels/1
  # PATCH/PUT /panels/1.json
  def update
    respond_to do |format|
      if @panel.update(panel_params)
        format.html { redirect_to phase_structure_path(@phase,@structure), notice_success: 'Panel updated!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @panel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /panels/1
  # DELETE /panels/1.json
  def destroy

    @panel.destroy
    respond_to do |format|

      format.html { redirect_to phase_structure_path(@phase,@structure) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def load_lineage
      @structure = Structure.find(params[:structure_id])
      @phase = Phase.find(@structure.phase_id)
      @job = Job.find(@phase.job_id)
      @client = Client.find(@job.client_id)
    end

    def set_panel
      @panel = Panel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def panel_params
      params.require(:panel).permit(:structure_id, :panel_model_id, :is_manufactured, :is_assembled, :side_position, :width, :height, :deflector, :buried, :door_width, :door_height, :door_inset_left)
    end

end