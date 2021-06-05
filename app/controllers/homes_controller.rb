class HomesController < ApplicationController
  def index
    @recipes = Recipe.includes(:favorites).page(params[:page]).limit(3)
    @consultations = Consultation.includes(:interests).page(params[:page]).per(3)
  end

  def tweet_index
    @tweet = current_user.feed.includes(:favorites).page(params[:page]).per(6)
  end
end
