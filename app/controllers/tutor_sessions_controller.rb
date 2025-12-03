class TutorSessionsController < ApplicationController
  # Only signed-in tutors should see their session lists
  before_action :require_tutor

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

  private

  def require_tutor
    redirect_to(new_login_path) and return unless current_tutor
  end
end