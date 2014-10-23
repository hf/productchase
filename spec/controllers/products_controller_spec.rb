require 'rails_helper'

describe ProductsController, :type => :controller do
  include UserSupport
  include ProductSupport

  describe "toggle" do
    before :all do
      create_product

      @params = {
        id: @product.id
      }
    end

    after :all do
      @user.destroy!
      @product.destroy!
    end

    it 'should create a new vote for user and product' do
      sign_in @user

      post :vote, @params

      vote = assigns(:vote)

      expect(vote.user).to eq @user
      expect(vote.votable).to eq @product

      expect(response).to redirect_to @product
    end

    it 'should destroy an existing vote for user and product' do
      existing_vote = Vote.create! user: @user, votable: @product
      sign_in @user

      post :vote, @params

      vote = assigns(:vote)
      expect(vote.destroyed?).to be true
      expect(@product.votes).to_not include(existing_vote)
      expect(response).to redirect_to @product
    end
  end

  describe 'create' do
    before :all do
      create_user

      @params =  {
          product: {
            link: 'http://github.com/hf/productchase',
            name: 'ProductChase',
            description: 'Recursion. Funny.'
        }
      }
    end

    after :all do
      @user.destroy!
    end

    it 'should create new product' do
      sign_in @user

      post :create, @params

      product = assigns(:product)

      expect(product.name).to eq @params[:product][:name]
      expect(product.link).to eq @params[:product][:link]
      expect(product.description).to eq @params[:product][:description]
      expect(product.persisted?).to be true

      expect(response).to redirect_to product_path(assigns(:product))
    end

    it 'should not create a new product' do
      sign_in @user

      @params[:product][:link] = ''

      post :create, @params

      expect(assigns(:product).persisted?).to be false
      expect(response).to render_template 'new'
    end
  end

  describe 'show' do
    before(:each) { create_product }

    it 'should show a product' do
      get :show, { id: @product.id }

      expect(assigns(:product)).to eq @product
      expect(response).to render_template 'show'
    end

    it 'should not show a product' do
      get :show, { id: @product.id + 1000 }

      expect(assigns(:product)).to be_falsy
      expect(response).to have_http_status 404
    end
  end

  describe 'edit' do
    before(:each) { create_product }

    it 'should edit a product' do
      sign_in @user

      get :edit, { id: @product.id }

      expect(assigns(:product)).to eq @product
      expect(response).to render_template 'edit'
    end

    it 'should not allow editing of another user\'s product' do
      create_user :intruder

      sign_in @user_intruder

      get :edit, { id: @product.id }

      expect(response).to have_http_status 404
    end

    it 'should not edit a product that does not exist' do
      sign_in @user

      get :edit, { id: @product.id + 1000 }

      expect(assigns(:product)).to be_falsy
      expect(response).to have_http_status 404
    end
  end

  describe 'update' do
    before(:each) { create_product }

    it 'should update a product' do
      sign_in @user

      @product.name = 'Updated Product Name'

      product = @product.attributes
      product.delete :user

      post :update, { id: @product.id, product: product }

      product = assigns(:product)

      expect(product.persisted?).to be true
      expect(product.name).to eq @product.name

      expect(response).to redirect_to product_path(@product)
    end

    it 'should not update a product due to non-existence' do
      sign_in @user

      product = @product.attributes
      product.delete :user

      post :update, { id: @product.id + 1000, product: product }

      expect(assigns(:product)).to be_falsy
      expect(response).to have_http_status 404
    end

    it 'should not update a product due to link uniqueness' do
      sign_in @user

      another_product = Product.create! \
        link: 'http://siyelo.com',
        name: 'Siyelo',
        user: @user

      @product.link = another_product.link

      product = @product.attributes
      product.delete :user

      post :update, { id: @product.id, product: product }

      product = assigns(:product)

      @product.reload

      expect(product).to eq @product
      expect(product.changed?).to be true
      expect(response).to render_template 'edit'
    end

    it 'should not allow updating another user\'s product' do
      create_user :intruder

      sign_in @user_intruder

      @product.name = 'Updated Product Name'

      product = @product.attributes
      product.delete :user

      post :update, { id: @product.id, product: product }

      expect(response).to have_http_status 404
    end
  end

  describe 'destroy' do
    before(:each) { create_product }

    it 'should delete an existing product' do
      sign_in @user

      delete :destroy, { id: @product.id }

      expect(assigns(:product).persisted?).to be false
      expect(response).to redirect_to products_path
    end

    it 'should not delete a non-existing product' do
      sign_in @user

      delete :destroy, { id: @product.id + 1000 }

      expect(assigns(:product)).to be_falsy
      expect(response).to have_http_status 404
    end

    it 'should not allow deleting another user\'s product' do
      create_user :intruder

      sign_in @user_intruder

      delete :destroy, { id: @product.id }

      expect(response).to have_http_status 404
    end
  end
end
