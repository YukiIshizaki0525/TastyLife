class HomesController < ApplicationController
  def index
    if user_signed_in?
      @list = Recipe.page(params[:page])
      @tweet = current_user.feed.limit(3)
    end
  end
end
