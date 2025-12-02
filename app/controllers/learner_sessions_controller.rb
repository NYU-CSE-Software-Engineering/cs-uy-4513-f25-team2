class LearnerSessionsController < ApplicationController
  # Only signed-in learners should see their session lists
  before_action :require_learner

  def index
    # Upcoming bookings for the current learner
    @upcoming_bookings = SessionAttendee
                           .upcoming_for(current_learner)
                           .includes(tutor_session: [:subject, :tutor])
  end

  def past
    # Past bookings for the current learner
    @past_bookings = SessionAttendee
                       .past_for(current_learner)
                       .includes(tutor_session: [:subject, :tutor])
  end
end