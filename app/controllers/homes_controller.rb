class HomesController < ApplicationController
  def index
    if user_signed_in?
      @list = Recipe.page(params[:page]).limit(3)
      @tweet = current_user.feed.limit(3)
    end
  end

  def tweet_index
    @tweet = current_user.feed
  end
end
