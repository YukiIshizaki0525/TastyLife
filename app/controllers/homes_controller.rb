class HomesController < ApplicationController
  def index
    @recipes = Recipe.includes([:favorites], [user: { avatar_attachment: :blob }], [image_attachment: :blob]).page(params[:page]).limit(3)
    @consultations = Consultation.includes([:interests], [user: { avatar_attachment: :blob }]).page(params[:page]).per(3)
  end

  def tweet_index
    @tweet = current_user.feed.includes([:favorites],  [user: { avatar_attachment: :blob }],[image_attachment: :blob]).page(params[:page]).per(6)
  end
end
