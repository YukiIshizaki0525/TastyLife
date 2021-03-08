class HomesController < ApplicationController
  def index
    @recipes = Recipe.page(params[:page]).limit(3)
    @consultations = Consultation.page(params[:page]).order(impressions_count: 'DESC')
    @tweet = current_user.feed.limit(3)
  end

  def tweet_index
    @tweet = current_user.feed
  end
end
