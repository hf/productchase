require 'rails_helper'

RSpec.describe VotesController, :type => :controller do
  include UserSupport
  include ProductSupport

  describe "visitor trying to vote" do
    before do
      create_product :ile
      post :create
    end

    specify{expect(response).to redirect_to(new_user_session_path)}
  end

  describe "user voting" do
    before do
      request.env["HTTP_REFERER"] = 'localhost:3000'
      create_product :ile
      sign_in @user_ile
      
    end

    it "creates vote for product" do
      post :create , { vote:{ votable_id: @product.id, votable_type: @product.class.to_s }}
      vote = assigns(:vote)
      expect(vote.user).to eq @user_ile
      expect(vote.votable).to eq @product
    end

    it 'creates a vote' do
      expect {
        post :create , { vote:{ votable_id: @product.id, votable_type: @product.class.to_s }}
      }.to change(Vote, :count).by(1)
    end
  end
end
