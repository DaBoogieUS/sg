class PanelModelsController < ApplicationController
  before_action :set_panel_model, only: [:show, :edit, :update, :destroy]

  # GET /panel_models
  # GET /panel_models.json
  def index
    @panel_models = PanelModel.all
    @panel_models_index = true
    @no_top_nav = true
  end

  # GET /panel_models/1
  # GET /panel_models/1.json
  def show
    @panel_models_show = true
    @no_top_nav = true
  end

  # GET /panel_models/new
  def new
    @panel_model = PanelModel.new
    @panel_models_new = true
    @no_top_nav = true
  end

  # GET /panel_models/1/edit
  def edit
    @panel_models_edit = true
    @no_top_nav = true
  end

  # POST /panel_models
  # POST /panel_models.json
  def create
    @panel_model = PanelModel.create(panel_model_params)

    respond_to do |format|
      if @panel_model.save
        format.html { redirect_to @panel_model, notice_success: 'Panel model created!' }
        format.json { render action: 'show', status: :created, location: @panel_model }
      else
        format.html { render action: 'new' }
        format.json { render json: @panel_model.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /panel_models/1
  # PATCH/PUT /panel_models/1.json
  def update
    respond_to do |format|
      if @panel_model.update(panel_model_params)
        format.html { redirect_to @panel_model, notice_success: 'Panel model updated!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @panel_model.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /panel_models/1
  # DELETE /panel_models/1.json
  def destroy
    @panel_model.destroy
    respond_to do |format|
      format.html { redirect_to panel_models_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_panel_model
      @panel_model = PanelModel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def panel_model_params
      params.require(:panel_model).permit(:name, :description, :panel_model_image)
    end
end
