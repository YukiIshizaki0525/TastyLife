class HomesController < ApplicationController
  before_action :authenticate_user!, only: [:tweet_index]
  
  def index
    if user_signed_in?
      @recipes = Recipe.includes([:favorites], [:user]).page(params[:page]).limit(3)
    else
      @recipes = Recipe.includes([:user]).page(params[:page]).limit(3)
    end
    @consultations = Consultation.includes(:interests, [:user]).page(params[:page]).per(3)
  end

  def tweet_index
    @title = "タイムライン"
    @tweet = current_user.feed.includes([:user], [:favorites], [:comments], [:tags]).page(params[:page]).per(6)
  end
end
