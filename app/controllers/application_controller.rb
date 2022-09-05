class ApplicationController < ActionController::Base
  before_action :basic_auth, if: :production?
  protect_from_forgery with: :exception
  before_action :authenticate_user!, except: [:new, :create]
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :reply_user_lists
  # include ErrorHandlers if Rails.env.production?

  # 退会ユーザー以外のユーザー名を全取得
  def reply_user_lists
    @users = User.where(leave_at: nil)
    @user_list = @users.select("user_name").map{|m| "@#{m.user_name}さん "}
  end

  protected

  # サインアップとユーザー更新の際は、added_attrsで指定したkeyの値をDBに保存する
  def configure_permitted_parameters
    added_attrs = [:avatar, :user_name, :user_dept, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  private

  # production判別
  def production?
    Rails.env.production?
  end

  # Basic認証不要IPアドレス
  def whitelisted?(ip)
    return true if [ENV['LOUNGE_IP_ADDRESS'], ENV['OFFICE_IP_ADDRESS'], ENV['CONF_ROOM_IP_ADDRESS']].include?(ip)
    false
  end

  # basic認証
  def basic_auth
    return false if whitelisted?(request.remote_ip) # 許可IPはBasic認証なし
    return false if request.user_agent === ENV["SPACY_USER_AGENT"] # 特定のUAの場合はBasic認証なし

    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end
end
