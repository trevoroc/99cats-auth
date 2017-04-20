class CatRentalRequestsController < ApplicationController
  before_action :check_owner

  def approve
    current_cat_rental_request.approve!
    redirect_to cat_url(current_cat)
  end

  def create
    @rental_request = CatRentalRequest.new(cat_rental_request_params)
    @rental_request.requester = current_user
    if @rental_request.save
      redirect_to cat_url(@rental_request.cat)
    else
      flash.now[:errors] = @rental_request.errors.full_messages
      render :new
    end
  end

  def deny
    current_cat_rental_request.deny!
    redirect_to cat_url(current_cat)
  end

  def new
    @rental_request = CatRentalRequest.new
  end

  private
  def current_cat_rental_request
    @rental_request ||=
      CatRentalRequest.includes(:cat).find(params[:id])
  end

  def current_cat
    current_cat_rental_request.cat
  end

  def cat_rental_request_params
    params.require(:cat_rental_request)
      .permit(:cat_id, :end_date, :start_date, :status)
  end

  def check_owner
    if %w(approve deny).include?(params[:action])
      if current_user.nil?
        flash[:errors] = ["Must be logged in to handle a request"]
        redirect_to cat_url(current_cat)
      elsif current_user
          .cats
          .where(id: current_cat.id)
          .empty?
        flash[:errors] = ["Not yo cat"]
        redirect_to cat_url(current_cat)
      end
    end
  end
end
