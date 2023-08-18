class PartTypesController < ApplicationController
  before_action :set_part_type, only: [:show, :edit, :update, :destroy]

  # GET /part_types
  # GET /part_types.json
  def index
    @part_types = PartType.all
    @part_types_index = true
    @no_top_nav = true
  end

  # GET /part_types/1
  # GET /part_types/1.json
  def show
    @part_types_show = true
    @no_top_nav = true
  end

  # GET /part_types/new
  def new
    @part_type = PartType.new(:nestable => true)
    @part_types_new = true
    @no_top_nav = true
  end

  # GET /part_types/1/edit
  def edit
    @part_types_edit = true
    @no_top_nav = true
  end

  # POST /part_types
  # POST /part_types.json
  def create
    @part_type = PartType.create(part_type_params)

    respond_to do |format|
      if @part_type.save
        format.html { redirect_to @part_type, notice_success: 'Part type created!' }
        format.json { render action: 'show', status: :created, location: @part_type }
      else
        format.html { render action: 'new' }
        format.json { render json: @part_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /part_types/1
  # PATCH/PUT /part_types/1.json
  def update
    respond_to do |format|
      if @part_type.update(part_type_params)
        format.html { redirect_to @part_type, notice_success: 'Part type updated!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @part_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /part_types/1
  # DELETE /part_types/1.json
  def destroy
    @part_type.destroy
    respond_to do |format|
      format.html { redirect_to part_types_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_part_type
      @part_type = PartType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def part_type_params
      params.require(:part_type).permit(:material_id, :name, :description, :part_type_image, :version, :nestable, :image_delete)
    end
end
