class Like < ApplicationRecord
  # バリデーション
  validates :user_id, {presence: true}
  validates :post_id, {presence: true}

  # テーブルの関連付け
  belongs_to :post, counter_cache: :likes_count
  belongs_to :user
end
