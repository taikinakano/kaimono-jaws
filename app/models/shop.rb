class Shop < ApplicationRecord

  belongs_to :user
  has_many :products, dependent: :destroy
  has_many :genres, dependent: :destroy
  has_many :favorites, dependent: :destroy
  attachment :image

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.search_for(content, method)
      Shop.where('conversion_shop_name LIKE ?', '%'+content+'%')
  end

  def self.searched_for(content, method)
      Shop.where('conversion_address LIKE ?', '%'+content+'%')
  end
end
