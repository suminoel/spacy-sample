class PostSerializer < ActiveModel::Serializer
  attributes :id, :content, :html_content, :og_card, :created_at, :user_id, :images, :likes_count, :reply_user_id, :reply_parent_id

  # 他テーブルとの関連付け
  belongs_to :user
  has_many :likes, dependent: :destroy
  # acts_as_taggable
end
