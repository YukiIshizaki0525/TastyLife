# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController

  def create
    super do
      resource.update(confirmed_at: Time .now.utc)
      #↓と同じ意味になります。
      # resource.skip_confirmation!
      # resource.save
    end
  end

  def after_inactive_sign_up_path_for(resource)
    root_path
  end

  protected
    # アカウント編集後、プロフィール画面に移動する
    def after_update_path_for(resource)
      user_path(id: current_user.id)
    end
end
