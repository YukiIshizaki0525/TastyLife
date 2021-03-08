# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :forbid_test_user, {only: [:edit,:update,:destroy]}

  def create
    super do
      # resource.update(confirmed_at: Time .now.utc)
      #↓と同じ意味になります。
      resource.skip_confirmation!
      resource.save
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
    def forbid_test_user
      if @user.email == "testuser@example.com"
        flash[:notice] = "テストユーザーのため変更できません"
        redirect_to root_path
      end
    end
end
