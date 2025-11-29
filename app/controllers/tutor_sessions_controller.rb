class TutorSessionsController < ApplicationController
  before_action :require_tutor 

  def new
    @tutor_session = TutorSession.new
  end

  def create
    @tutor_session = TutorSession.new(tutor_session_params)
    @tutor_session.tutor = current_tutor
    @tutor_session.status = "open"

    if @tutor_session.save
      redirect_to tutor_session_path(@tutor_session), notice: 'Session successfully created'
    else
      @errors = @tutor_session.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @tutor_session = TutorSession.find(params[:id])
  end

  private

  def tutor_session_params
    params.require(:tutor_session).permit(
      #:tutor_id,  
      :subject_id,
      :start_at,
      :end_at,
      :capacity
    )
  end
  def require_tutor
    return if current_tutor
    redirect_to new_login_path, alert: 'You must be logged in as a tutor'
  end
end
