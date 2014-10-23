class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_not_comment_author, only: :destroy

  def create
    @product = Product.find(params[:product_id])
    @comment = current_user.comments.build(text: params[:comment][:text], product: @product)
    if @comment.save
      redirect_to @product
    else
      @users = @product.vote_users
      render "products/show"
    end
  end

  def destroy
    @comment.destroy
    redirect_to Product.find(params[:product_id])
  end

  private

  def redirect_if_not_comment_author
    @comment = Comment.find(params[:id])
    redirect_to Product.find(params[:product_id]) unless current_user == @comment.user
  end
end
