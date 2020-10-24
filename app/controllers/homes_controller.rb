class HomesController < ApplicationController
  def index
    if user_signed_in?
      @newrecipes = Recipe.page(params[:page])
      @recipes = current_user.feed.limit(3)

    end
  end
end
