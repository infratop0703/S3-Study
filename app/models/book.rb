class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments,dependent: :destroy
  has_many :favorites,dependent: :destroy
  
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  
  scope :latest, -> {order(created_at: :desc)}
  scope :star, -> {order(star: :desc)}
  
  
  
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
  
end
