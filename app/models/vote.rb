class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user, presence: true
  validates :votable, presence: true
  validates :user, uniqueness: { scope: [:votable_id,:votable_type] }
end