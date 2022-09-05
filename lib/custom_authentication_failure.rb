class CustomAuthenticationFailure < Devise::FailureApp
protected
  def redirect_url
    new_user_session_path #rootに飛ばす場合
  end
end