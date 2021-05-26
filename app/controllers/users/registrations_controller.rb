# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :forbid_test_user, {only: [:edit,:update,:destroy]}

  def create
    super do
      resource.update(confirmed_at: Time.now.utc)
      #↓と同じ意味になります。
      resource.avatar.attach(io: File.open("app/assets/images/default_user.png"), filename: "default_user.png")
      # resource.skip_confirmation!
      resource.save
      #WelcomeMailerクラスのsend_when_signupメソッドを呼び、POSTから受け取ったuserのemailとnameを渡す
      # WelcomeMailer.send_when_signup(params[:user][:email],params[:user][:name]).deliver
    end
  end

  def after_inactive_sign_up_path_for(resource)
    # ユーザー登録後のリダイレクト先を指定
    root_path
  end

  protected
    # アカウント編集後、プロフィール画面に移動する
    def after_update_path_for(resource)
      user_path(id: current_user.id)
    end

  private
    # ゲストユーザーの更新・削除不可
    def forbid_test_user
      if resource.email == "guest@example.com"
        flash[:alert] = "ゲストユーザーの更新・削除はできません。"
        redirect_to root_path
      end
    end
end
