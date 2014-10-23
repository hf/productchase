require 'rails_helper'

describe CommentsController, :type => :controller do
  include UserSupport
  include ProductSupport

  describe "visitor can't comment" do 
    before :all do
      create_product
    end
    after :all do
      @product.destroy
      @user.destroy
    end

    it "should be redirected to sign in" do   
      post :create, { comment:{text: "Hello!"},product_id: @product.id} 

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "signed in user can comment" do
    before :all do 
      create_product
    end

    after :all do
      @product.destroy
      @user.destroy
    end

    it "should create a comment" do
    sign_in @user

    expect{post :create, product_id: @product.id,comment:{text: "Hello"}}.to change(Comment, :count).by(1) 
    end
  end
end
