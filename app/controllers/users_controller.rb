class UsersController < ApplicationController
	before_action :authenticate_user!, except: :show

  def show 
    @user = User.find_by_twitter_username(params[:twitter_username])
    @products = @user.vote_products
  end

  def edit
  	@user = User.find_by_twitter_username(params[:twitter_username])
  	render "settings"
  end

  def update
  	@user = User.find_by_twitter_username(params[:twitter_username])
  	if @user.update_attributes(user_params)
  		flash[:notice] = "Your profile has been updated!"
  		redirect_to @user
  	else
  		render "settings"
  	end
  end

  private

  def user_params
  	params.require(:user).permit(:personal_title)
  end
end