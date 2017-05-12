class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]
  before_action :logged_in_user, :correct_user, only: %i[edit update]

  def index; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'Welcome to the Sample App!'
      redirect_to @user
    else
      render 'new'
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy; end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'Please log in.'
      redirect_to log_in_url
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
