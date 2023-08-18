class PartsController < ApplicationController
  before_filter :load_lineage
  before_action :set_part, only: [:show, :edit, :update, :destroy]

  # GET /parts
  # GET /parts.json
  def index
    @parts = Part.all
    @parts_index = true
  end

  # GET /parts/1
  # GET /parts/1.json
  def show
    @parts_show = true
  end

  # GET /parts/new
  def new
    @part = Part.new
    @parts_new = true
  end

  # GET /parts/1/edit
  def edit
    @parts_edit = true
  end

  # POST /parts
  # POST /parts.json
  def create
    @part = Part.new(part_params)

    respond_to do |format|
      if @part.save
        format.html { redirect_to panel_part_path(@panel,@part), notice_success: 'Part created!' }
        format.json { render action: 'show', status: :created, location: @part }
      else
        format.html { render action: 'new' }
        format.json { render json: @part.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parts/1
  # PATCH/PUT /parts/1.json
  def update
    respond_to do |format|
      if @part.update(part_params)
        format.html { redirect_to panel_part_path(@panel,@part), notice_success: 'Part updated!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @part.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parts/1
  # DELETE /parts/1.json
  def destroy
    @part.destroy
    respond_to do |format|
      format.html { redirect_to panel_parts_url(@panel) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def load_lineage
      @panel = Panel.find(params[:panel_id])
      @structure = Structure.find(@panel.structure_id)
      @phase = Phase.find(@structure.phase_id)
      @job = Job.find(@phase.job_id)
      @client = Client.find(@job.client_id)
    end

    def set_part
      @part = Part.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def part_params
      params.require(:part).permit(:part_type_id, :panel_id, :length, :width, :height, :count)
    end
end
