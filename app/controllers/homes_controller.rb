class HomesController < ApplicationController
  def index
    @recipes = Recipe.includes([:favorites], [:user]).page(params[:page]).limit(3)
    @consultations = Consultation.includes(:interests, [:user]).page(params[:page]).per(3)
  end

  def tweet_index
    @tweet = current_user.feed.includes([:user], [:favorites], [:comments]).page(params[:page]).per(6)
  end
end
