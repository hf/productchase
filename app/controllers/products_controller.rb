class ProductsController < ApplicationController
  rescue_from ActiveRecord::RecordNotUnique, with: :not_unique

  before_action :authenticate_user!, except: :show

  def index
    days = params[:days].to_i
    days = 3 if days < 1

    @products_by_day = ProductGrouping.new Product.n_days_worth days

    render layout: !request.xhr?
  end

  def create
    @product = Product.new product_params
    @product.user = current_user

    if @product.save
      redirect_to @product
    else
      render 'new'
    end
  end

  def show
    @product = Product.find_by! id: params[:id]
    @users = @product.vote_users
    @comment  = Comment.new(product: @product)
    @comments = @product.comments
  end

  def update
    @product = Product.find_by! id: params[:id], user: current_user

    if @product.update product_params
      redirect_to @product
    else
      render 'edit'
    end
  end

  def destroy
    @product = Product.find_by! id: params[:id], user: current_user
    @product.destroy

    redirect_to products_path
  end

  def new
    @product = Product.new user: current_user
  end

  def edit
    @product = Product.find_by! id: params[:id], user: current_user
  end


  def vote
    @product = Product.find(params[:id])
    @vote = current_user.votes.find_by(votable: @product)

    if @vote
      @vote.destroy!
    else
      @vote = current_user.votes.create(votable: @product)
    end

    redirect_to @product
  end

  private
  def product_params
    params.require(:product).permit(:link, :name, :description)
  end

  def not_unique exception
    render plain: "#{exception}\nAsk for a manual change.", status: 400
  end
end
