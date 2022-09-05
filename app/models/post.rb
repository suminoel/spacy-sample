class Post < ApplicationRecord
  # ImageUploaderを使用できるようにする
  mount_uploaders :images, ImageUploader

  # タグを使用できるようにする
  acts_as_taggable

  # バリデーション
  validates :content, {presence: true}
  validates :user_id, {presence: true}

  # 他テーブルとの関連付け
  has_many :likes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  # has_many :post_tags, dependent: :destroy
  # has_many :tags, through: :post_tags

  # scope :from_tag, -> (tag_id)  { where(id: post_ids = PostTag.where(tag_id: tag_id).select(:post_id))}

  # postに紐付いているuserの情報を取得
  def user
    return User.find_by(id: self.user_id)
  end

  # user_idに紐づくlikesを取得
  # user_id integer
  def like_user(user_id)
    likes.find_by(user_id: user_id)
  end

  # user_idに紐づくbookmarksを取得
  # user_id integer
  def bookmark_user(user_id)
    bookmarks.find_by(user_id: user_id)
  end

  # def save_tags(tags)
  #   current_tags = self.tags.pluck(:name) unless self.tags.nil?
  #   old_tags = current_tags - tags
  #   new_tags = tags - current_tags

  #   # Destroy old taggings:
  #   old_tags.each do |old_name|
  #     self.tags.delete Tag.find_by(name:old_name)
  #   end

  #   # Create new taggings:
  #   new_tags.each do |new_name|
  #     post_tag = Tag.find_or_create_by(name:new_name)
  #     self.tags << post_tag
  #   end
  # end
end
