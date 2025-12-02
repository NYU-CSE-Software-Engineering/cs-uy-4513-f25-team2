class FeedbacksController < ApplicationController
  before_action :require_learner

  def new
    @tutor_session = TutorSession.find(params[:session_id])
    @tutor = @tutor_session.tutor
    @feedback = Feedback.new
  end

  def create
    @tutor_session = TutorSession.find(feedback_params[:tutor_session_id])
    @tutor = @tutor_session.tutor

    @feedback = Feedback.new(
      tutor_session: @tutor_session,
      learner: current_learner,
      tutor: @tutor,
      score: feedback_params[:score],
      comment: feedback_params[:comment]
    )

    if @feedback.save
      redirect_to home_path, notice: 'Thank you for your feedback!'
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:tutor_session_id, :score, :comment)
  end
end


