class SessionsController < ApplicationController
  before_action :check_user_logged_in

  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(params[:user][:user_name], params[:user][:password])
    if @user
      login(@user)
      redirect_to cats_url
    else
      render :new
    end
  end

  def destroy
    logout
    redirect_to cats_url
  end

  private

  def check_user_logged_in
    # fail
    if current_user && params[:action] == "new"
      flash[:errors] = ["You are already logged in!"]
      redirect_to cats_url
    end
  end
end
