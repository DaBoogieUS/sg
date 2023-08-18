class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  def index
    if @current_user.role == 'admin'
      @users = User.all
      @no_top_nav = true
    else
      redirect_to root_url
    end
  end

  def new
    if @current_user.role == 'admin' || @user == @current_user
      @user = User.new
      @no_top_nav = true
    else
      redirect_to root_url
    end
  end

  def edit
    if @current_user.role == 'admin' || @user == @current_user
      @no_top_nav = true
    else
      redirect_to root_url
    end
  end

  def create
    @user = User.create(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice_success: 'User created' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to request.referer, notice_success: 'User successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_path }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def set_user
      @user = User.find(params[:id])
    end
    def user_params
      params.require(:user).permit(:username, :password_salt, :password_hash, :password, :role)
    end
end
