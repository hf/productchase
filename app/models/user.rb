class User < ActiveRecord::Base
  before_create :twitter_username_downcase

  has_many :products, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :vote_products, through: :votes, source: :votable, source_type: "Product"
  has_many :comments, dependent: :destroy
  has_many :vote_comments, through: :votes, source: :votable, source_type: "Comment"

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable, :omniauthable

  validates :name, presence: true

  validates :uid, presence: true
  validates :provider, presence: true

  validates :uid, uniqueness: { scope: :provider, case_insensitive: true }

  validates :twitter_username, uniqueness: { case_insensitive: true }, presence: true
  validates :personal_title, length:{maximum: 40}

  def self.find_or_create_for_oauth auth
    user = User.find_by uid: auth.uid, provider: auth.provider
    return user unless user.nil?

    user = User.create! uid: auth.uid, \
      provider: auth.provider,
      password: Devise.friendly_token,
      name: auth.extra.raw_info.name,
      twitter_username: auth.extra.raw_info.screen_name,
      twitter_pic: auth.extra.raw_info.profile_image_url_https
  end

  def name= name
    write_attribute :name, name.strip if name.respond_to? :strip
  end

  def twitter_username= username
    write_attribute :twitter_username, username.strip if username.respond_to? :strip
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def gives_vote_to(votable)
    votes.create(votable: votable)
  end

  def voted?(product)
    votes.find_by(product: product)
  end

  def to_param
    twitter_username
  end

  private

    def twitter_username_downcase
      twitter_username.downcase!
    end
end