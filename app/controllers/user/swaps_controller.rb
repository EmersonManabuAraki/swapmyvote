class User::SwapsController < ApplicationController
  before_action :require_login
  before_action :assert_incoming_swap_exists, :only => [:update, :destroy]

  def show
    if @user.is_swapped?
      redirect_to user_path
      return
    end
    @potential_swaps = @user.potential_swaps.limit(5)
  end
  
  def new
    @swap_with = User.find(params[:user_id])
  end
  
  def create
    @user.swap_with_user_id(params[:user_id])
    if !@user.errors.empty?
      flash[:errors] = @user.errors.full_messages()
    end
    redirect_to user_path
  end
  
  def update
    confirmed = (swap_params[:confirmed] == "true")
    @user.incoming_swap.update(confirmed: confirmed)    
    redirect_to user_path  
  end
  
  def destroy
    @user.incoming_swap.destroy
    redirect_to user_path
  end
  
private
  def assert_incoming_swap_exists
    if !@user.incoming_swap
      flash[:errors] = "You don't have a swap!"
      redirect_to user_path
    end
  end

  def swap_params
    params.require(:swap).permit(:confirmed)
  end
end