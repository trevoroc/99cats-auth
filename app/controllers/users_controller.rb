class UsersController < ApplicationController
  before_action :check_user_logged_in

  def new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(@user)
      redirect_to cats_url
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to new_user_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end

  def check_user_logged_in
    # fail
    if current_user && params[:action] == "new"
      flash[:errors] = ["You are already logged in!"]
      redirect_to cats_url
    end
  end
end
