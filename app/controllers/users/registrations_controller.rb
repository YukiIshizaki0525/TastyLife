# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def new
    @user = User.new
  end
  def create
    @user = User.create params.require(:user).permit(:avatar)
    if avatar = params[:user][:avatar]
      @user.avatar.attach(avatar)
    end
  end

  protected
    # アカウント編集後、プロフィール画面に移動する
    def after_update_path_for(resource)
      user_path(id: current_user.id)
    end
end
