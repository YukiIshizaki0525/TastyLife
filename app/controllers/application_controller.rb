class ApplicationController < ActionController::Base
  # CSRF対策
  protect_from_forgery with: :exception

  # ログイン済みユーザーのみアクセス許可
  before_action :authenticate_user!

  # deviseコントローラーにストロングパラメータを追加する
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  
  def configure_permitted_parameters
    added_attrs = [:name, :email, :password, :password_confirmation, :remeber_me]
    # 新規登録時のストロングパラメータ
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    # アカウント編集時のストロングパラメータ
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
