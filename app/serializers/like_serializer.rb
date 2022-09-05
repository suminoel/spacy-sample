class LikeSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :post_id, :created_at, :updated_at

  # テーブルの関連付け
  belongs_to :post, counter_cache: :likes_count
  belongs_to :user
end
