class SessionsController < ApplicationController
  before_action :require_learner
  before_action :current_session, only: [:show, :update, :confirm, :book]
  before_action :require_authorization, only: [:show, :update]

  def show; end

  def update
    if params[:session_attendee][:attended].blank?
      flash.now[:alert] = "No attendance option selected."
      render :show, status: :unprocessable_content
      return
    end

    if @tutor_session.start_at > Time.current
      flash.now[:alert] = "Cannot mark attendance for sessions that have not yet occurred."
      render :show, status: :unprocessable_content
      return
    end

    learner = Learner.find(params[:session_attendee][:learner_id])
    attendee = SessionAttendee.find_or_initialize_by(
      tutor_session: @tutor_session,
      learner: learner
    )
    attendee.attended = (params[:session_attendee][:attended] == "true")

    if attendee.save
      message = attendee.attended ? "Learner marked as present" : "Learner marked as absent"
      redirect_to session_path(@tutor_session), notice: message
    else
      flash.now[:alert] = "Failed to save attendance."
      render :show, status: :unprocessable_content
    end
  end

  def search; end

  def results
    subject_name = params[:subject]
    @subject = Subject.find_by(name: subject_name)

    if @subject.nil?
      @sessions = []
      return
    end

    @start_time = Time.zone.parse(params[:start_at])
    @end_time = Time.zone.parse(params[:end_at]).end_of_minute

    @sessions = TutorSession
      .where(subject_id: @subject.id)
      .where('start_at >= ? AND end_at <= ?', @start_time, @end_time)
      .where(status: 'Scheduled')
      .order(:start_at)
  end

  def confirm; end

  def book
    if SessionAttendee.exists?(tutor_session: @tutor_session, learner: current_learner)
      redirect_to confirm_session_path(@tutor_session), alert: "You are already booked for that session"
      return
    end
  end

  private

  def require_learner
    return if current_learner
    redirect_to new_login_path
  end

  def current_session
    @tutor_session = TutorSession.find(params[:id])
  end

  def require_authorization
    current_tutor = Tutor.find_by(learner: current_learner)
    return if current_tutor && @tutor_session.tutor == current_tutor
    redirect_to new_login_path
  end
end
