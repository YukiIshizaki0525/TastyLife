class InterestsController < ApplicationController
  before_action :consultation_params

  def create
    current_user.interests.create(consultation_id: @consultation.id)
  end

  def destroy
    current_user.interests.find_by(consultation_id: @consultation.id).destroy
  end

  def consultation_params
    @consultation = Consultation.find(params[:consultation_id])
  end
end
