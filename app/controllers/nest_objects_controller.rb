class NestObjectsController < ApplicationController
  before_action :set_nest_object, only: [:show, :edit, :update, :destroy]

  # GET /nest_objects
  # GET /nest_objects.json
  def index
    @nest_objects = NestObject.all
  end

  # GET /nest_objects/1
  # GET /nest_objects/1.json
  def show
  end

  # GET /nest_objects/new
  def new
    @nest_object = NestObject.new
  end

  # GET /nest_objects/1/edit
  def edit
  end

  # POST /nest_objects
  # POST /nest_objects.json
  def create
    @nest_object = NestObject.new(nest_object_params)

    respond_to do |format|
      if @nest_object.save
        format.html { redirect_to @nest_object, notice_success: 'Nest object created!' }
        format.json { render action: 'show', status: :created, location: @nest_object }
      else
        format.html { render action: 'new' }
        format.json { render json: @nest_object.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nest_objects/1
  # PATCH/PUT /nest_objects/1.json
  def update
    respond_to do |format|
      if @nest_object.update(nest_object_params)
        format.html { redirect_to @nest_object, notice_success: 'Nest object updated!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @nest_object.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nest_objects/1
  # DELETE /nest_objects/1.json
  def destroy
    @nest_object.destroy
    respond_to do |format|
      format.html { redirect_to nest_objects_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nest_object
      @nest_object = NestObject.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def nest_object_params
      params.require(:nest_object).permit(:part_id, :nest_id, :x, :y, :rotated)
    end
end
