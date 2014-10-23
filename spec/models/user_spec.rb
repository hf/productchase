require 'rails_helper'

describe User, :type => :model do
  include UserSupport
  include ProductSupport
  include SanitationSupport
  include ValidationSupport

  describe "gives_vote_to" do
    before :all do
      create_product
    end

    let(:vote){@user.gives_vote_to @product}

    after :all do
      @user.destroy
      @product.destroy
    end

    it "should respond to the method" do
      expect(@user).to respond_to(:gives_vote_to)
    end

    it "vote should equal user" do
      expect(vote.user).to eq @user
      expect(vote.votable).to eq @product 
    end
  end

  describe 'validations' do
    it 'should require presence of uid' do
      validate_with_errors uid: nil
    end

    it 'should requrie presence of provider' do
      validate_with_errors provider: nil
    end

    it 'should require presence of name' do
      validate_with_errors name: nil
    end
  end

  describe 'sanitation' do
    it 'should strip whitespace from name' do
      sanitize_before_validation dirty: { name: ' ProductChase ' }, clean: { name: 'ProductChase' }
    end

    it 'should strip whitespace from twitter_username' do
      sanitize_before_validation dirty: { twitter_username: ' product_chase ' }, clean: { twitter_username: 'product_chase' }
    end

    it 'should not crash with a nil twitter_username' do
      sanitize_before_validation dirty: { twitter_username: nil }, clean: { twitter_username: nil }
    end
  end
end
