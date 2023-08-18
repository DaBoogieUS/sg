class MaterialsController < ApplicationController
  before_action :set_material, only: [:show, :edit, :update, :destroy]

  # GET /materials
  # GET /materials.json
  def index
    @materials = Material.all
    @materials_index = true
    @no_top_nav = true
  end

  # GET /materials/1
  # GET /materials/1.json
  def show
    @materials_show = true
    @no_top_nav = true
  end

  # GET /materials/new
  def new
    @material = Material.new
    @materials_new = true
    @no_top_nav = true
  end

  # GET /materials/1/edit
  def edit
    @materials_edit = true
    @no_top_nav = true
  end

  # POST /materials
  # POST /materials.json
  def create
    @material = Material.new(material_params)

    respond_to do |format|
      if @material.save
        format.html { redirect_to @material, notice_success: 'Material created!' }
        format.json { render action: 'show', status: :created, location: @material }
      else
        format.html { render action: 'new' }
        format.json { render json: @material.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /materials/1
  # PATCH/PUT /materials/1.json
  def update
    respond_to do |format|
      if @material.update(material_params)
        format.html { redirect_to @material, notice_success: 'Material updated!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @material.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /materials/1
  # DELETE /materials/1.json
  def destroy
    @material.destroy
    respond_to do |format|
      format.html { redirect_to materials_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_material
      @material = Material.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def material_params
      params.require(:material).permit(:name, :cut_spacing, :width, :height, :count, :length, :material_type, :length_options => [])
    end
end
