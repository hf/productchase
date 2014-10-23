require 'uri'
require 'rails_helper'

describe Product, :type => :model do
  include UserSupport
  include ProductSupport
  include ValidationSupport
  include SanitationSupport

  it { should validate_presence_of :link }
  it { should validate_presence_of :name }
  it { should respond_to(:vote_users)}

  describe "user that voted product" do
    before do
      create_user :vlatko
      create_product
      @user_vlatko.gives_vote_to(@product)
    end

    specify{expect(@product.vote_users).to include(@user_vlatko)}
  end

  describe 'validations' do
    it 'should not allow invalid HTTP/HTTPS links' do
      validate_with_errors link: 'http://!invalid!.com'
    end

    it 'should allow valid HTTP/HTTPS links' do
      validate_without_errors link: 'HtTp://example.com'
    end

    it 'should allow scheme-less links' do
      validate_without_errors link: ' example.com '
    end

    it 'should not allow short names' do
      validate_with_errors name: ''
    end

    it 'should not allow huge names' do
      validate_with_errors name: 'P' * 26
    end

    it 'should allow long-enough names' do
      validate_without_errors name: 'P' * 25
    end

    it 'should not allow a huge description' do
      validate_with_errors description: 'P' * 61
    end

    it 'should allow a reasonable description' do
      validate_without_errors description: 'P' * 60
    end

    it 'should not allow a userless product' do
      validate_with_errors user: nil
    end

    it 'should not allow a product with an invalid user' do
      create_user

      @user.password = 'pswd'

      validate_with_errors user: @user
    end

    it 'should allow a product with a valid user' do
      create_user
      validate_without_errors user: @user
    end
  end

  describe 'sanitation' do
    it 'should sanitize names, links, descriptions' do
      sanitize_before_validation \
        dirty: {
          name: ' ProductChase ',
          link: ' HtTP://uripasswords:suck@goOgLe.COM:8080/path#hello?test=ing&what=ever/ ',
          description: ' A truly lovely product. '},
        clean: {
          name: 'ProductChase',
          link: 'http://google.com/path',
          description: 'A truly lovely product.' }
    end
  end

  describe 'before_create' do
    it 'should set day_of_entry to current day' do
      create_user
      p = Product.create! name: 'ProductChase BC', link: 'http://github.com/hf/productchase/bc', user: @user

      expect(p.day_of_entry).to eq Time.zone.now.midnight
    end
  end

  describe 'nth_day' do
    it 'should return the 3rd day of the products starting from today' do
      create_user
      products = [
        Product.create!(name: 'PC ND 1', link: 'http://github.com/hf/productchase/nd1', user: @user),
        Product.create!(name: 'PC ND 2', link: 'http://github.com/hf/productchase/nd2', user: @user, created_at: 1.day.ago, day_of_entry: 1.day.ago.midnight),
        Product.create!(name: 'PC ND 3', link: 'http://github.com/hf/productchase/nd3', user: @user, created_at: 3.days.ago, day_of_entry: 3.days.ago.midnight)
      ]

      expect(Product.nth_day(3)).to eq (Time.zone.now - 3.days).midnight
    end
  end

  describe 'n_days_worth' do
    it 'should return 3 days worth of products starting from today and tomorrow' do
      create_user

      products = [
        Product.create!(name: 'PC ND 1', link: 'http://github.com/hf/productchase/nd1', user: @user),
        Product.create!(name: 'PC ND 2', link: 'http://github.com/hf/productchase/nd2', user: @user, created_at: 1.day.ago, day_of_entry: 1.day.ago.midnight),
        Product.create!(name: 'PC ND 3', link: 'http://github.com/hf/productchase/nd3', user: @user, created_at: 3.days.ago, day_of_entry: 3.days.ago.midnight),
        Product.create!(name: 'PC ND 4', link: 'http://github.com/hf/productchase/nd4', user: @user, created_at: 4.days.ago, day_of_entry: 4.days.ago.midnight)
      ]

      actual = Product.n_days_worth(3)

      expect(actual.length).to eq (3)
      expect(products - actual).to eq [products.last]

      actual = Product.n_days_worth(3, 1.day.ago.midnight)
    end
  end
end
