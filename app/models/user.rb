class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :confirmable,
         :recoverable, :rememberable, :validatable, :registerable

  # AvatarUploaderを使えるようにする
  mount_uploader :avatar, AvatarUploader

  before_validation do
    self.uid = email if uid.blank?
  end

  # user_id（自身のid）に紐付くpostを取得
  def posts
    return Post.where(user_id: self.id)
  end

  # アカウント削除を押したときの処理
  def leave
    # userのメールアドレスの頭にleave_atを追加する。
    # メールアドレスを変更すると原則確認メールが送信されるため、
    # 送信をスキップすることを宣言した上でupdateする。
    leave_time = DateTime.current
    new_email = leave_time.to_i.to_s + '_' + self.email.to_s
    self.skip_reconfirmation!
    update_attributes(:email => new_email, :user_name => "退会ユーザー", :leave_at => leave_time, :remove_avatar => true)
  end

  # @return [Boolean] cookieを使いログイン情報を保持するかどうか -> ここではtrue
  def remember_me
    true
  end

  # ユーザー情報の更新時、パスワード入力なしで更新するメソッド
  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

end
