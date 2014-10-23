require 'rails_helper'

RSpec.describe Comment, :type => :model do
  include UserSupport
  include ProductSupport

  describe "validations" do
    before :all do
      create_product
    end

    after :all do
      @product.destroy
      @user.destroy
    end

    describe "text can't be blank" do

      it "should be invalid" do
        comment = @user.comments.create(text:"", product: @product)

        expect(comment).to be_invalid
      end

      it "should be valid" do
        comment = @user.comments.create(text:"Hello", product: @product)
        expect(comment).to be_valid
      end
    end

    describe "user must exist" do

      it "should be invalid" do
        comment = @product.comments.create(text:"Hello", user: nil)

        expect(comment).to be_invalid
      end

      it "should be valid" do
        comment = @product.comments.create(text:"Hello", user: nil)

        expect(comment).to be_invalid
      end
    end
  end

  it "every user should have unique comments" do
    create_product
    comment  = @user.comments.create(text:"Hello", product: @product)
    comment1 = @user.comments.create(text:"Hello", product: @product)

    expect(comment1).to be_invalid
  end

  describe "default scope of the comments" do
    before :each do
      create_product
    end

    it "should be invalid" do
      comment  = @user.comments.create(text:"Hi", product: @product, created_at: 1.hour.ago)
      comment1 = @user.comments.create(text:"Hello", product: @product, created_at: 1.day.ago)

      expect(@user.comments.to_a).not_to eq [comment1,comment]
    end

    it "should be valid" do
      comment  = @user.comments.create(text:"Hi", product: @product, created_at: 1.hour.ago)
      comment1 = @user.comments.create(text:"Hello", product: @product, created_at: 1.day.ago)
      expect(@user.comments.to_a).to eq [comment,comment1]
    end
  end
end
