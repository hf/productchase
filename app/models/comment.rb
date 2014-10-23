class Comment < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  has_many :votes, as: :votable

  validates :text, presence: true, uniqueness:{scope: :user}
  validates :product, presence: true
  validates :user, presence: true
  default_scope -> {order("created_at DESC")}
end