class TutorSessionsController < ApplicationController
  # Only signed-in tutors should see their session lists
  before_action :require_tutor
  before_action :set_tutor_session, only: [:edit, :update]
  before_action :authorize_tutor, only: [:edit, :update]

  def index
    # Upcoming sessions for the current tutor
    @upcoming_sessions = TutorSession
      .where(tutor_id: current_tutor.id, status: 'scheduled')
      .where("start_at >= ?", Time.current)
      .includes(:subject)
      .order(:start_at)
  end

  def past
    # Past sessions for the current tutor
    @past_sessions = TutorSession
      .where(tutor_id: current_tutor.id, status: 'completed')
      .or(
        TutorSession.where(tutor_id: current_tutor.id)
          .where("end_at < ?", Time.current)
      )
      .includes(:subject)
      .order(start_at: :desc)
  end

  def edit;end

  def update
    if @tutor_session.update(tutor_session_params)
      redirect_to tutor_sessions_path , notice: 'Session updated successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def require_tutor
    redirect_to(new_login_path) and return unless current_tutor
  end

  def tutor_session_params
    params.require(:tutor_session).permit(:meeting_link)
  end

  def set_tutor_session
    @tutor_session = TutorSession.find(params[:id])
  end

  def authorize_tutor
    unless @tutor_session.tutor == current_tutor
      flash.now[:alert] = "You cannot edit another tutor's session"
      redirect_to new_login_path
    end
  end
end
