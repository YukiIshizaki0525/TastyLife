# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  protected
    # アカウント編集後、プロフィール画面に移動する
    def after_update_path_for(resource)
      user_path(id: current_user.id)
    end
end
