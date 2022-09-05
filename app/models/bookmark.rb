class Bookmark < ApplicationRecord
  # バリデーション
  validates :user_id, {presence: true}
  validates :post_id, {presence: true}

  # テーブルの関連付け
  belongs_to :post, counter_cache: :bookmarks_count
  belongs_to :user
end
